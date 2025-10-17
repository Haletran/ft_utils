const { GObject, St, Clutter, GLib, Gio } = imports.gi;
const Main = imports.ui.main;
const PanelMenu = imports.ui.panelMenu;
const PopupMenu = imports.ui.popupMenu;
const ByteArray = imports.byteArray;

const REFRESH_INTERVAL = 30; 
const WARNING_THRESHOLD = 0.9;

// format bytes
function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}


// get directory size using du command
function getDirectorySize(path) {
    return new Promise((resolve, reject) => {
        try {
            let proc = Gio.Subprocess.new(
                ['du', '-sb', path],
                Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE
            );
            
            proc.communicate_utf8_async(null, null, (proc, result) => {
                try {
                    let [, stdout, stderr] = proc.communicate_utf8_finish(result);
                    if (proc.get_successful()) {
                        let size = parseInt(stdout.split('\t')[0]);
                        resolve(size);
                    } else {
                        reject(new Error(stderr));
                    }
                } catch (e) {
                    reject(e);
                }
            });
        } catch (e) {
            reject(e);
        }
    });
}

const DiskUsageIndicator = GObject.registerClass(
    class DiskUsageIndicator extends PanelMenu.Button {
        _init() {
            super._init(0.0, 'Disk Usage Monitor');
            
            this.homePath = GLib.get_home_dir();
            this.usagePercentage = 0;
            this.totalSize = 0;
            this.usedSize = 0;
            
            this._createUI();
            this._startMonitoring();
        }
        
        _createUI() {
            // main container
            this.mainBox = new St.BoxLayout({
                style_class: 'panel-status-menu-box disk-usage-main-box',
                vertical: false,
                y_align: Clutter.ActorAlign.CENTER
            });
            
            // icon
            this.icon = new St.Icon({
                icon_name: 'drive-harddisk-symbolic',
                style_class: 'system-status-icon disk-usage-icon',
                icon_size: 16
            });
            
            // gauge container
            this.gaugeContainer = new St.BoxLayout({
                style_class: 'disk-usage-gauge-container',
                vertical: false,
                y_align: Clutter.ActorAlign.CENTER
            });
            
            // gauge background
            this.gaugeBackground = new St.Widget({
                style_class: 'disk-usage-gauge-bg',
                width: 50,
                height: 4
            });
            
            // gauge fill
            this.gaugeFill = new St.Widget({
                style_class: 'disk-usage-gauge-fill',
                width: 0,
                height: 4
            });
            
            // position gauge fill
            this.gaugeBackground.add_child(this.gaugeFill);
            this.gaugeContainer.add_child(this.gaugeBackground);
            
            // percentage label
            this.percentageLabel = new St.Label({
                text: '0%',
                style_class: 'disk-usage-percentage',
                y_align: Clutter.ActorAlign.CENTER
            });
            
            this.mainBox.add_child(this.icon);
            this.mainBox.add_child(this.gaugeContainer);
            this.mainBox.add_child(this.percentageLabel);
            this.add_child(this.mainBox);
            
            // popup menu
            this._createPopupMenu();
        }
        
        _createPopupMenu() {
            this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
            
            // Add header with detailed usage info
            this.usageHeader = new PopupMenu.PopupMenuItem('Loading...', {
                reactive: false,
                style_class: 'disk-usage-header'
            });
            this.menu.addMenuItem(this.usageHeader);
            this.usageDetails = new PopupMenu.PopupMenuItem('', {
                reactive: false,
                style_class: 'disk-usage-details'
            });
            this.cleaningDetails = new PopupMenu.PopupMenuItem('', {
                reactive: true,
                style_class: 'disk-usage-details'
            });
            this.menu.addMenuItem(this.usageDetails);
            this.menu.addMenuItem(this.cleaningDetails);

            this.isCleaning = false;  // Add cleaning state flag
    
            this.cleaningDetails.connect('activate', () => {
                this._handleCleaning();
            });
        }
        
        _startMonitoring() {
            this._updateUsage();
            
            // Set up periodic updates
            this.updateTimeout = GLib.timeout_add_seconds(
                GLib.PRIORITY_DEFAULT,
                REFRESH_INTERVAL,
                () => {
                    this._updateUsage();
                    return GLib.SOURCE_CONTINUE;
                }
            );
        }
        _handleCleaning() {
            if (this.isCleaning) return;

            this.isCleaning = true;
            this.cleaningDetails.setSensitive(false);
            this.cleaningDetails.label.set_text('🔄 Cleaning storage...');
            const paths = [
                GLib.build_filenamev([this.homePath, '.cache']),
                GLib.build_filenamev([this.homePath, 'Trash']),
                GLib.build_filenamev([this.homePath, '.thumbnails'])
                // add more path here if needed
            ];
            
            let proc = Gio.Subprocess.new(
                ['rm', '-rf', ...paths],
                Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE
            );
            const cleanStorage = () => {
                return new Promise((resolve, reject) => {
                    proc.communicate_utf8_async(null, null, (proc, result) => {
                        try {
                            let [, stdout, stderr] = proc.communicate_utf8_finish(result);
                            if (proc.get_successful()) {
                                resolve();
                            }
                            else {
                                reject(new Error(stderr));
                            }
                        } catch (e) {
                            reject(e);
                        }
                    });
                });
            };
            cleanStorage()
                .then(() => {
                    this.cleaningDetails.label.set_text('✅ Storage cleaned successfully!');
                    this._updateUsage();

                    // Reset after 3 seconds
                    GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 3, () => {
                        this.cleaningDetails.label.set_text('Click here to clean storage');
                        this.cleaningDetails.setSensitive(true);
                        this.isCleaning = false;
                        return GLib.SOURCE_REMOVE;
                    });
                })
                .catch((e) => {
                    log(`Disk Usage Monitor: Cleaning failed: ${e.message}`);
                    this.cleaningDetails.label.set_text('❌ Cleaning failed. Try again.');

                    GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 3, () => {
                        this.cleaningDetails.label.set_text('Click here to clean storage');
                        this.cleaningDetails.setSensitive(true);
                        this.isCleaning = false;
                        return GLib.SOURCE_REMOVE;
                    });
                });
        }   

        _updateUsage() {
            // Get total size and used size of home directory
            getDirectorySize(this.homePath).then((usedSize) => {
                this.usedSize = usedSize;
                
                // Get filesystem info for total capacity
                let file = Gio.File.new_for_path(this.homePath);
                file.query_filesystem_info_async(
                    'filesystem::*',
                    GLib.PRIORITY_DEFAULT,
                    null,
                    (file, result) => {
                        try {
                            let info = file.query_filesystem_info_finish(result);
                            this.totalSize = info.get_attribute_uint64('filesystem::size');
                            this.usagePercentage = this.usedSize / this.totalSize;
                            
                            this._updateUI();
                            this._updatePopupContent();
                        } catch (e) {
                            log(`Disk Usage Monitor: Error getting filesystem info: ${e.message}`);
                        }
                    }
                );
            }).catch((e) => {
                log(`Disk Usage Monitor: Error updating usage: ${e.message}`);
            });
        }
        
        _updateUI() {
            // Update percentage label
            let percentage = Math.round(this.usagePercentage * 100);
            this.percentageLabel.set_text(`${percentage}%`);
            
            // Update gauge fill width with smooth animation
            let fillWidth = Math.max(1, Math.round(50 * this.usagePercentage));
            this.gaugeFill.set_width(fillWidth);
            
            // Change color based on usage with better thresholds
            let color;
            if (this.usagePercentage >= WARNING_THRESHOLD) {
                color = '#f44336'; // Red for critical
            } else if (this.usagePercentage >= 0.75) {
                color = '#ff9800'; // Orange for warning
            } else if (this.usagePercentage >= 0.5) {
                color = '#2196f3'; // Blue for moderate
            } else {
                color = '#4caf50'; // Green for low usage
            }
            
            // Apply color to gauge fill
            this.gaugeFill.style_class = 'disk-usage-gauge-fill';
            this.gaugeFill.set_style(`background-color: ${color};`);
        }
        
        _updatePopupContent() {
            // Update header
            let usedFormatted = formatBytes(this.usedSize);
            let totalFormatted = formatBytes(this.totalSize);
            let percentage = Math.round(this.usagePercentage * 100);
            let freeSpace = formatBytes(this.totalSize - this.usedSize);
            
            // Add status indicator based on usage
            let statusIcon = '';
            if (this.usagePercentage >= WARNING_THRESHOLD) {
                statusIcon = '🔴 ';
            } else if (this.usagePercentage >= 0.75) {
                statusIcon = '🟡 ';
            } else {
                statusIcon = '🟢 ';
            }
            
            this.usageHeader.label.set_text(
                `${statusIcon}Home Directory (${percentage}%)`
            );
            
            this.usageDetails.label.set_text(
                `Used: ${usedFormatted} of ${totalFormatted}\nFree Space: ${freeSpace}\nPath: ${this.homePath}`
            );
            // Only set initial text if not currently cleaning
            if (!this.isCleaning) {
                this.cleaningDetails.label.set_text(
                    `Click here to clean storage.`
                );
            }

        }
        
        destroy() {
            if (this.updateTimeout) {
                GLib.source_remove(this.updateTimeout);
                this.updateTimeout = null;
            }
            super.destroy();
        }
    }
);

class Extension {
    constructor() {
        this.indicator = null;
    }
    
    enable() {
        this.indicator = new DiskUsageIndicator();
        Main.panel.addToStatusArea('disk-usage-monitor', this.indicator);
    }
    
    disable() {
        if (this.indicator) {
            this.indicator.destroy();
            this.indicator = null;
        }
    }
}

function init() {
    return new Extension();
}

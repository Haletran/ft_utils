const St = imports.gi.St;
const Gio = imports.gi.Gio;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Main = imports.ui.main;
const Mainloop = imports.mainloop;
const PanelMenu = imports.ui.panelMenu;

let debounceTimeout = null;

class Extension {
    constructor() {
        this._indicator = null;
    }
    
    enable() {
        log(`enabling ${Me.metadata.name}`);

        let indicatorName = `${Me.metadata.name} Indicator`;
        
        // Create a panel button
        this._indicator = new PanelMenu.Button(0.0, indicatorName, false);
        
        // Add an icon
        let icon = new St.Icon({
            gicon: new Gio.ThemedIcon({name: 'system-lock-screen-symbolic'}),
            style_class: 'system-status-icon'
        });
        this._indicator.add_child(icon);
	this._indicator.connect('button-press-event', _lock);

        // `Main.panel` is the actual panel you see at the top of the screen,
        // not a class constructor.
        Main.panel.addToStatusArea(indicatorName, this._indicator);
    }
    
    // REMINDER: It's required for extensions to clean up after themselves when
    // they are disabled. This is required for approval during review!
    disable() {
        log(`disabling ${Me.metadata.name}`);

        this._indicator.destroy();
        this._indicator = null;
    }
}

function _lock() {
  if (debounceTimeout === null) {
    debounceTimeout = Mainloop.timeout_add(420, function() {
      debounceTimeout = null;

      // change the path to where the script is located
      let preLockProc = Gio.Subprocess.new(['/home/bapasqui/bin/custom-lockscreen', '-af'], 0);

      preLockProc.wait_async(null, (proc, res) => {
        try {
          proc.wait_finish(res); // Wait for pre-lock script to finish

          let lockProc = Gio.Subprocess.new(['/usr/share/42/ft_lock'], 0);
          lockProc.wait_async(null, null);

        } catch (e) {
          log(`Error running pre-lock script: ${e}`);
        }
      });

      return false;
    });
  }
}

function init() {
    log(`initializing ${Me.metadata.name}`);
    
    return new Extension();
}


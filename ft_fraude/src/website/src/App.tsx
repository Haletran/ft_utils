import { use, useEffect, useState } from 'react'
import { Lock, LockOpen, KeyRound } from 'lucide-react'
import './App.css'

function App() {
  const [output, setOutput] = useState('')
  const [program, setProgram] = useState('')
  const [lockStatus, setLockStatus] = useState(false)
  const [lockTimestamp, setLockTimestamp] = useState<number | null>(() => {
    const saved = localStorage.getItem('lockTimestamp')
    return saved ? parseInt(saved) : null
  })
  const [elapsedTime, setElapsedTime] = useState('')

  const formatElapsedTime = (timestamp: number) => {
    const now = Date.now()
    const diff = now - timestamp
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((diff % (1000 * 60)) / 1000)
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
  }

  const launchProgram = async (program: string) => {
    try {
      if (program.toLowerCase().includes('cat')) {
        throw new Error('Command not allowed');
      }
      const response = await fetch('/api/launch-program', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ program }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setOutput(data.output || data.error);
    } catch (error) {
      setOutput('Error launching program: ' + error);
    }
  };

  const unlock = async () => {
    try {
      if (!lockStatus) {
        setOutput('Computer already unlocked');
        return;
      }
      const str = `xdotool type --delay 100 ${import.meta.env.VITE_PASSWORD} && xdotool key Return`;
      const response = await fetch('/api/launch-program', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ program: str }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setOutput(data.output || data.error);
      setLockTimestamp(null)
      localStorage.removeItem('lockTimestamp')
      setElapsedTime('')
    } catch (error) {
      setOutput('Error launching program: ' + error);
    }
  }

  const isLocked = async () => {
    try {
      const response = await fetch('/api/launch-program', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ program: "pidof ft_lock" }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      const isLocked = data.output.trim().split(/\s+/).length > 1;
      if (isLocked) {
        setLockStatus(true);
        if (!lockTimestamp) {
          const timestamp = Date.now()
          setLockTimestamp(timestamp)
          localStorage.setItem('lockTimestamp', timestamp.toString())
        }
        return true;
      } else {
        setLockStatus(false);
        setLockTimestamp(null)
        localStorage.removeItem('lockTimestamp')
        setElapsedTime('')
        return false;
      }
    } catch (error) {
      setOutput('Error checking lock status: ' + error);
    }
  }

  const lock = async () => {
    try {
      if (lockStatus) {
        setOutput('Computer already locked');
        return;
      }
      const response = await fetch('/api/launch-program', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ program: "ft_lock" }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setOutput(data.output || data.error);
      const timestamp = Date.now()
      setLockTimestamp(timestamp)
      localStorage.setItem('lockTimestamp', timestamp.toString())
    } catch (error) {
      setOutput('Error launching program: ' + error);
    }
  }

  useEffect(() => {
    const interval = setInterval(() => {
      isLocked();
      if (lockTimestamp) {
        setElapsedTime(formatElapsedTime(lockTimestamp))
      }
    }, 100);
    return () => clearInterval(interval);
  }, [lockTimestamp]);

  useEffect(() => {
    const checkInitialState = async () => {
      const isCurrentlyLocked = await isLocked();
      if (isCurrentlyLocked && lockTimestamp) {
        setElapsedTime(formatElapsedTime(lockTimestamp));
      }
    };
    checkInitialState();
  }, []);

  // need to add a way of autologin if the computer is locked for more than 40 minutes

  return (
    <>
      <div className="card">
        <div className="mb-4 text-center">
        {lockStatus && (
            <div className="flex items-center gap-2 text-white justify-center w-full">
              <p className='text-white font-bold'>Locked for:</p>
              <span className={`font-mono ${elapsedTime.includes('41:') || elapsedTime.includes('42:') || elapsedTime.includes('43:') ? 'text-red-500' : ''}`}>{elapsedTime}</span>
            </div>
          )}
        </div>
        <div className="card-header flex gap-4 justify-center mb-4">
          <button
            onClick={lockStatus ? unlock : lock}
            className='p-2 rounded-full hover:bg-gray-200 hover:scale-110 transition-all duration-200 flex items-center gap-2'
            title={lockStatus ? "Unlock screen" : "Lock screen"}
          >
            {lockStatus ? <KeyRound size={24} /> : <Lock size={24} />}
            <span className="font-bold">
              {lockStatus ? "Unlock" : "Lock"}
            </span>
          </button>
        </div>
        <div className="flex flex-col gap-4 w-full max-w-md">
            <div className="flex gap-2">
            <input
              type="text"
              value={program}
              placeholder="Enter command"
              onChange={(e) => setProgram(e.target.value)}
              onKeyDown={(e) => {
              if (e.key === 'Enter') {
                launchProgram(program);
              }
              }}
              className="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <button
              onClick={() => launchProgram(program)}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors duration-200"
            >
              Run
            </button>
            </div>
          {output && (
            <pre className="p-4 bg-gray-200 text-black rounded-lg overflow-x-auto text-sm">
              {output}
            </pre>
          )}
        </div>
      </div>
    </>
  )
}

export default App

import { exec } from 'node:child_process';
import type { Connect } from 'vite';
import type { IncomingMessage, ServerResponse } from 'node:http';

type NextFunction = () => void;

export function setupServerHandlers(app: any) {
  app.use((req: IncomingMessage, res: ServerResponse, next: NextFunction) => {
    const remoteAddress = req.socket.remoteAddress;

    if (
      remoteAddress === '::1' || 
      remoteAddress === '127.0.0.1' || 
      remoteAddress?.startsWith('::ffff:127.')
    ) {
      return next();
    }

    res.writeHead(403);
    res.end('Access denied');
  });
  app.use(async (req: IncomingMessage, res: ServerResponse, next: NextFunction) => {
    if (req.url === '/api/launch-program' && req.method === 'POST') {
      let body = '';
      
      req.on('data', (chunk: Buffer) => {
        body += chunk.toString();
      });

      req.on('end', () => {
        try {
          const { program } = JSON.parse(body);
          
          if (!program) {
            res.statusCode = 400;
            res.end(JSON.stringify({ error: 'Program command is required' }));
            return;
          }

          exec(program, (error: Error | null, stdout: string, stderr: string) => {
            if (error) {
              console.error(`Error: ${error}`);
              res.statusCode = 500;
              res.end(JSON.stringify({ error: error.message }));
              return;
            }
            res.end(JSON.stringify({ output: stdout }));
          });
        } catch (error) {
          res.statusCode = 400;
          res.end(JSON.stringify({ error: 'Invalid JSON in request body' }));
        }
      });
    } else {
      next();
    }
  });
} 
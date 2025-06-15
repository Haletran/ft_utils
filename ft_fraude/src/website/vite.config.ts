import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { setupServerHandlers } from './src/server-handler'
import path from "path"
import tailwindcss from "@tailwindcss/vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
    
    {
      name: 'configure-server',
      configureServer(server) {
        setupServerHandlers(server.middlewares);
      },
      
    },
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: { 
    host: true,               // bind to 0.0.0.0 so localtunnel can reach it
    port: 5173,               // optional, but good to set
    strictPort: true,         // fail if port is taken
    allowedHosts: true, 
    proxy: {
      '/api': {
        target: 'http://localhost:5173',
        changeOrigin: true,
      },
    },
  },
})

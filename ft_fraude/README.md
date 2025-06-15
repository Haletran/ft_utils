# ft_fraude

Nightmare to setup..

Launch the script `setup`, it will install xdotool and the dependencies.
And also `ngrok` for the localtunnel. 

> ! Attention : To use ngrok, you need to create an `account` and get your `token`.

> ! Another Warning : for now this script is only working on old sessions that are running the old greeter

```bash
chmod +x setup
./setup
```
Then you need to setup the ngrok token with this command : 

```bash
ngrok config add-authtoken your token
# the token is in `Getting Started -> Your Authtoken`
```

You also need to setup the `.env` file for the website : 

```bash
cp .env.example .env
#add your session password to the .env file
# VITE_PASSWORD=password

## TODO : need to find a better way to do this
```

> ! Attention : You can have a `free custom domain` in ngrok, but you need to create it in the ngrok `dashboard -> domains`.

If you have a custom domain then add it in the `URL` var in the `launch` file.

Then launch the launch script : 

```bash
#if you want to setup an alias
echo "alias ft_fraude='bash ~/ft_fraude/launch'" >> ~/.bashrc

chmod +x launch
./launch

#or you can modify the ft_lock gnome extension to launch the script before the locking process
# you can find the modified extension in lock@bapasqui.fr

```



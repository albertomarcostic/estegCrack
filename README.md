# EstegCrack.sh

## How it works?

EstegCrack.sh allows you to perform a brute-force attack on an image that has a file or archive hidden by steganography inside the image and protected with a password. 
This bash script iterates over the default Rockyou.txt dictionary passwords. 

## Parameters

- **-i** -> Provide the image to crack
- **-w** -> Provide the list of password words to crack the image

-------------------

## Dependencies
- steghide
```shell
apt install steghide
```

## Usage
```shell
 ./estegCrack -i image.jpg -w wordlist.txt
 ./estegCrack -i penguin.jpg -w /usr/share/wordlists/rockyou.txt
```
![image](https://github.com/albertomarcostic/estegCrack/assets/131155486/464e7d9d-fa43-4e71-9fd3-a4f57b6fbd0a)


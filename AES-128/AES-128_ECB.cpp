// Простенькая реализация алгоритма шифрования AES-128 в режиме ECB(не рекомендуется) с  функцией выработки ключа PBKDF2-HMAC-SHA1.
// Используется бибилотека CryptoPP
// sudo apt-get install libcrypto++-dev
// ... -lcryptopp

#include <iostream>
#include <fstream>
#include <string>
#include <cryptopp/aes.h>
#include <cryptopp/modes.h>
#include <cryptopp/filters.h>
#include <cryptopp/hex.h>
#include <cryptopp/pwdbased.h>
#include <cryptopp/sha.h>

using namespace std;
using namespace CryptoPP;

int main() 
{
    // Ввод пароля
    string password;
    cout << "Введите пароль: ";
    cin >> password;

    // Ввод соли
    string salt;
    cout << "Введите соль: ";
    cin >> salt;

    // Входные параметры
    int iterations = 1000;
    int dkLen = 16; // Длина ключа в байтах (128 бит)

    // Выработка ключа с использованием PBKDF2-HMAC-SHA1
    SecByteBlock key(dkLen);
    PKCS5_PBKDF2_HMAC<SHA1> pbkdf2;
    pbkdf2.DeriveKey(key, key.size(), 0, (byte*)password.data(), password.size(), (byte*)salt.data(), salt.size(), iterations);

    int choice;
    cout << "Выберите действие: " << endl;
    cout << "1. Зашифровать данные" << endl;
    cout << "2. Расшифровать данные" << endl;
    cout << "Ваш выбор: ";
    cin >> choice;

    if (choice == 1) 
    {
        // Ввод имени файла с исходными данными
        string input_file;
        cout << "Введите имя файла с исходными данными: ";
        cin >> input_file;
        
        // Открытие файла с исходными данными
        ifstream ifs(input_file, ios::binary);
        if (!ifs) 
        {
            cerr << "Не удалось открыть файл с исходными данными." << endl;
            return 1;
        }

        // Чтение данных из файла
        string data((istreambuf_iterator<char>(ifs)), (istreambuf_iterator<char>()));

        // Шифрование данных с использованием AES-128 в режиме ECB
        string ciphertext;
        ECB_Mode<AES>::Encryption e;
        e.SetKey(key, key.size());
        StringSource(data, true,
            new StreamTransformationFilter(e,
                new StringSink(ciphertext)
            )
        );

        // Запись зашифрованных данных в файл
        string output_file = "output.txt";
        ofstream ofs(output_file, ios::binary);
        if (!ofs) 
        {
            cerr << "Не удалось создать файл для записи зашифрованных данных." << endl;
            return 1;
        }
        ofs << ciphertext;
        ofs.close();

        cout << "Исходные данные: " << data.size() << " байт" << endl;
        cout << "Зашифрованные данные: " << ciphertext.size() << " байт" << endl;
        cout << "Зашифрованные данные записаны в файл: " << output_file << endl;
    } 
    else if (choice == 2) 
    {
        // Ввод имени файла с зашифрованными данными
        string input_file;
        cout << "Введите имя файла с зашифрованными данными: ";
        cin >> input_file;
        // Открытие файла с зашифрованными данными
        ifstream ifs(input_file, ios::binary);
        if (!ifs) 
        {
            cerr << "Не удалось открыть файл с зашифрованными данными." << endl;
            return 1;
        }

        // Чтение зашифрованных данных из файла
        string ciphertext((istreambuf_iterator<char>(ifs)), (istreambuf_iterator<char>()));

        // Расшифрование данных с использованием AES-128 в режиме ECB
        string decryptedtext;
        ECB_Mode<AES>::Decryption d;
        d.SetKey(key, key.size());
        StringSource(ciphertext, true,
            new StreamTransformationFilter(d,
                new StringSink(decryptedtext)
            )
        );

        // Запись расшифрованных данных в файл
        string output_file = "output.txt";
        ofstream ofs(output_file, ios::binary);
        if (!ofs) 
        {
            cerr << "Не удалось создать файл для записи расшифрованных данных." << endl;
            return 1;
        }
        ofs << decryptedtext;
        ofs.close();

        cout << "Зашифрованные данные: " << ciphertext.size() << " байт" << endl;
        cout << "Расшифрованные данные: " << decryptedtext.size() << " байт" << endl;
        cout << "Расшифрованные данные записаны в файл: " << output_file << endl;
    } 
    else 
    {
        cout << "Некорректный выбор. Выход из программы." << endl;
        return 1;
    }

    return 0;
}

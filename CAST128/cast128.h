#ifndef CAST128_H
#define CAST128_H
#include <stdint.h>
class CAST128 
{
	private:
	typedef uint32_t SType[ 256 ];
	static const SType S1;
	static const SType S2;
	static const SType S3;
	static const SType S4;
	static const SType S5;
	static const SType S6;
	static const SType S7;
	static const SType S8;
	
	public:
	enum 
	{
		KEY_LEN = 128 / 32,
		MSG_LEN = 2
	};
	typedef uint32_t Key[ KEY_LEN ];
	typedef uint32_t Message[ MSG_LEN ];

	void run( const Key key, Message msg, bool reverse = false );
	CAST128();
	void encrypt( const Key key, Message msg );
	void decrypt( const Key key, Message msg );
};
#endif 

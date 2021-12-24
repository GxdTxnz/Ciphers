#include "cast128.h"
#include "cast128.cpp"
#include <iostream>
#include <iomanip>
#include <stdio.h>
void showComponent( uint32_t x ) 
{
	std::cout << std::hex << std::setw( 8 ) << std::setfill( '0' ) << std::uppercase << x << " ";
}
void showMessage( const CAST128::Message msg ) 
{
	for( int i = 0; i < CAST128::MSG_LEN; ++i ) 
	{
		showComponent( msg[ i ] ); std::cout << " ";
	}
	std::cout << std::endl;
}
void showKey( const CAST128::Key key ) 
{
	for( int i = 0; i < CAST128::KEY_LEN; ++i ) 
	{
		showComponent( key[ i ] ); std::cout << " ";
	}
	std::cout << std::endl;
}

int main() 
{
	CAST128 cast128;
	std::cout << "================ Test 1 ================" << std::endl;
	static const CAST128::Key KEY = { 0x01234567, 0x12345678, 0x23456789, 0x3456789A };
	CAST128::Message msg = { 0x01234567, 0x89ABCDEF };
	std::cout << "          Msg before: "; showMessage( msg );
	cast128.encrypt( KEY, msg );
	std::cout << "Msg after encryption: "; showMessage( msg );
	cast128.decrypt( KEY, msg );
	std::cout << "Msg after decryption: "; showMessage( msg );
	std::cout << std::endl;

	std::cout << "================ Test 2 ================" << std::endl;
	CAST128::Key a = { 0x01234567, 0x12345678, 0x23456789, 0x3456789A };
	CAST128::Key b = { 0x01234567, 0x12345678, 0x23456789, 0x3456789A };
	for( int i = 0; i < 1000000; ++i ) 
	{
		cast128.encrypt( b, a );
		cast128.encrypt( b, a + 2 );
		cast128.encrypt( a, b );
		cast128.encrypt( a, b + 2 );
	}
	showKey( a );
	showKey( b );
	return 0;
}

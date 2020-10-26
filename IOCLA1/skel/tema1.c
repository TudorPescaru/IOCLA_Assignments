// Copyright 2020 Pescaru Tudor-Mihai 321CA
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

static int write_stdout(const char *token, int length)
{
	int rc;
	int bytes_written = 0;

	do {
		rc = write(1, token + bytes_written, length - bytes_written);
		if (rc < 0)
			return rc;

		bytes_written += rc;
	} while (bytes_written < length);
    
	return bytes_written;
}

int iocla_printf(const char *format, ...)
{
    // Strings used to convert int/hex to text format
	char digit[] = "0123456789", hex[] = "0123456789abcdef";
	char char_arg, *string_arg, *buffer;
	int count = 0, i = 0, int_arg, int_shift, len, ok;
	unsigned int uint_arg, uint_shift;
	va_list args;
    
    // Start reading arguments
    va_start(args, format);
    
    // Iterate over characters in format string
    while (i < strlen(format)) {
        // Check if current character is the specifier character
        if (format[i] == '%') {
            // Move to next character to determine type of arg
            i++;
            // Argument is a signed int
            if (format[i] == 'd') {
                // Read next arg
                int_arg = va_arg(args, int);
                // Check if the int is negative
                ok = 0;
                if (int_arg < 0) {
                    ok = 1;
                }
                // Calculate number of digits in the int
                int_shift = int_arg;
                len = 0;
                while (int_shift) {
                    len++;
                    int_shift /= 10;
                }
                // Allocate a buffer to store the string variant of the int
                buffer = (char*)malloc((len + 1) * sizeof(char));
                buffer[len] = '\0';
                // Populate buffer from back to front with the last digit 
                // of the int
                buffer += len;
                do {
                    // If the int is negative, the digit is converted
                    if (int_arg % 10 < 0) {
                        *--buffer = digit[(int_arg % 10) * -1];
                    } else {
                        *--buffer = digit[int_arg % 10];
                    }
                    int_arg /= 10;
                } while (int_arg);
                // Write '-' sign for negative numbers
                if (ok) {
                    count += write_stdout("-", 1);
                }
                // Write the buffer and free
                count += write_stdout(buffer, strlen(buffer));
                free(buffer);
            }
            // Argument is unsigned int
            if (format[i] == 'u') {
                // Read argument and convert to unsigned
                uint_arg = (unsigned int)va_arg(args, int);
                // Calculate number of digits in the uint
                uint_shift = uint_arg;
                len = 0;
                while (uint_shift) {
                    len++;
                    uint_shift /= 10;
                }
                // Allocate buffer to store string variant of uint
                buffer = (char*)malloc((len + 1) * sizeof(char));
                buffer[len] = '\0';
                // Populate buffer from back to front
                buffer += len;
                do {
                    *--buffer = digit[uint_arg % 10];
                    uint_arg /= 10;
                } while (uint_arg);
                // Write buffer and free
                count += write_stdout(buffer, strlen(buffer));
                free(buffer);
            }
            // Argument is char
            if (format[i] == 'c') {
                // Read argument and write directly
                char_arg = va_arg(args, int);
                count += write_stdout(&char_arg, 1);
            }
            // Argument is hexa
            if (format[i] == 'x') {
                // Read argument and convert to uint
                uint_arg = (unsigned int)va_arg(args, int);
                // Calculate length of uint hexa representation
                uint_shift = uint_arg;
                len = 0;
                while (uint_shift) {
                    len++;
                    uint_shift /= 16;
                }
                // Allocate buffer to store string variant of hexa
                buffer = (char*)malloc((len + 1) * sizeof(char));
                buffer[len] = '\0';
                // Populate buffer from back to front using hexa digits
                buffer += len;
                do {
                    *--buffer = hex[uint_arg % 16];
                    uint_arg /= 16;
                } while (uint_arg);
                // Write buffer and free
                count += write_stdout(buffer, strlen(buffer));
                free(buffer);
            }
            // Argument is string
            if (format[i] == 's') {
                // Read argument and write directly
                string_arg = va_arg(args, char*);
                count += write_stdout(string_arg, strlen(string_arg));
            }
            // Special case to escape specifier character
            if (format[i] == '%') {
                count += write_stdout(&format[i], 1);
            }
        } else {
            // No arg parsing needed, just write from format
            count += write_stdout(&format[i], 1);
        }
        i++;
    }

    va_end(args);

    // Check if writing was successful and return number of writes
    if (count != 0) {
        return count;
    } else {
	    return -1;
	}
}

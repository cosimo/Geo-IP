#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GeoIP.h"

#ifdef __cplusplus
}
#endif

MODULE = Geo::IP	PACKAGE = Geo::IP

PROTOTYPES: DISABLE

GeoIP *
new(CLASS,flags = 0)
	char * CLASS
	int flags
    CODE:
	RETVAL = GeoIP_new(flags);
    OUTPUT:
	RETVAL

GeoIP *
open(CLASS,filename,flags = 0)
	char * CLASS
	char * filename
	int flags
    CODE:
	RETVAL = GeoIP_open(filename,flags);
    OUTPUT:
	RETVAL

char *
country_code_by_addr(gi, addr)
	GeoIP *gi
	char * addr
    CODE:
	RETVAL = (char *)GeoIP_country_code_by_addr(gi,addr);
    OUTPUT:
	RETVAL

char *
country_code_by_name(gi, name)
	GeoIP *gi
	char * name
    CODE:
	RETVAL = (char *)GeoIP_country_code_by_name(gi,name);
    OUTPUT:
	RETVAL

char *
country_code3_by_addr(gi, addr)
	GeoIP *gi
	char * addr
    CODE:
	RETVAL = (char *)GeoIP_country_code3_by_addr(gi,addr);
    OUTPUT:
	RETVAL

char *
country_code3_by_name(gi, name)
	GeoIP *gi
	char * name
    CODE:
	RETVAL = (char *)GeoIP_country_code3_by_name(gi,name);
    OUTPUT:
	RETVAL

char *
country_name_by_addr(gi, addr)
	GeoIP *gi
	char * addr
    CODE:
	RETVAL = (char *)GeoIP_country_name_by_addr(gi,addr);
    OUTPUT:
	RETVAL

char *
country_name_by_name(gi, name)
	GeoIP *gi
	char * name
    CODE:
	RETVAL = (char *)GeoIP_country_name_by_name(gi,name);
    OUTPUT:
	RETVAL

void
DESTROY(gi)
	GeoIP *gi
    CODE:
	GeoIP_delete(gi);

#ifndef DATASOURCE_H
#define DATASOURCE_H
.string stringfield_null;
CLASS(DataSource, Object)
    ATTRIB(DataSource, entryIcon, .string, stringfield_null)
    ATTRIB(DataSource, entryName, .string, stringfield_null)
    METHOD(DataSource, getEntry, entity(int))
    METHOD(DataSource, indexOf, int(string))
    METHOD(DataSource, reload, int(string))
    METHOD(DataSource, destroy, void(entity))
ENDCLASS(DataSource)
#endif

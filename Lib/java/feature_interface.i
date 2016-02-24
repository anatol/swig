%define DECLARE_INTERFACE_(INTERFACE, IMPL, CTYPE...)
%feature("interface", name="INTERFACE") CTYPE;
%typemap(jtype) CTYPE, CTYPE *, CTYPE *const&, CTYPE [], CTYPE & "long"
%typemap(jstype) CTYPE, CTYPE *, CTYPE *const&, CTYPE [], CTYPE & "INTERFACE"
%typemap(javain) CTYPE, CTYPE & "$javainput." ## #INTERFACE ## "_SWIGInterfaceUpcast()"
%typemap(javain) CTYPE *, CTYPE *const&, CTYPE [] "($javainput == null) ? 0 : $javainput." ## #INTERFACE ## "_SWIGInterfaceUpcast()"
%typemap(javaout) CTYPE {
    return (INTERFACE)new IMPL($jnicall, true);
  }
%typemap(javaout) CTYPE & {
    return (INTERFACE)new IMPL($jnicall, $owner);
  }
%typemap(javaout) CTYPE *, CTYPE *const&, CTYPE [] {
    long cPtr = $jnicall;
    return (cPtr == 0) ? null : (INTERFACE)new IMPL(cPtr, $owner);
  }
%typemap(javadirectorin) CTYPE, CTYPE & "(INTERFACE)new IMPL($jniinput, false)"
%typemap(javadirectorin) CTYPE *, CTYPE *const&, CTYPE [] "($jniinput == 0) ? null : (INTERFACE)new IMPL($jniinput, false)"
%typemap(javadirectorout) CTYPE, CTYPE *, CTYPE *const&, CTYPE [], CTYPE & "$javacall." ## #INTERFACE ## "_SWIGInterfaceUpcast()"
%typemap(directorin, descriptor="L$packagepath/" ## #INTERFACE ## ";") CTYPE *, CTYPE &, CTYPE *const&, CTYPE [], CTYPE & 
%{ $input = 0;
   *(($&1_ltype*)&$input) = &$1;
%}
%typemap(javainterfacecode, declaration="  long $interfacename_SWIGInterfaceUpcast();\n", cptrmethod="$interfacename_SWIGInterfaceUpcast") CTYPE %{
  public long $interfacename_SWIGInterfaceUpcast() {
    return $imclassname.$javaclazzname$interfacename_SWIGInterfaceUpcast(swigCPtr);
  }
%}
SWIG_JAVABODY_PROXY(public, protected, CTYPE)
%enddef

%define DECLARE_INTERFACE_RENAME(INTERFACE, IMPL, CTYPE...)
%rename (IMPL) CTYPE;
DECLARE_INTERFACE_(INTERFACE, IMPL, CTYPE)
%enddef

%define DECLARE_INTERFACE(INTERFACE, CTYPE...)
DECLARE_INTERFACE_(INTERFACE, CTYPE, CTYPE)
%enddef


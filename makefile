PROJECT=LevenshteinDistance
EXECUTABLE=distance
KIT=$(PROJECT)Kit
TARGET=target

LANG=en_US.US-ASCII
MACOSX_DEPLOYMENT_TARGET=10.7

TOOLCHAIN=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
LD=${TOOLCHAIN}/ld
CLANG=${TOOLCHAIN}/clang
LIBTOOL=${TOOLCHAIN}/libtool
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
MACOSXSDK=$(SYSROOT)/MacOSX$(MACOSX_DEPLOYMENT_TARGET).sdk
ISYSROOT=-isysroot $(MACOSXSDK)
SYSLIBROOT=-syslibroot $(MACOSXSDK)
MMACOSX_VERSION_MIN=-mmacosx-version-min=$(MACOSX_DEPLOYMENT_TARGET)

all: $(TARGET)/lib$(PROJECT).dylib $(TARGET)/$(EXECUTABLE) $(TARGET)/lib$(PROJECT).a

$(TARGET)/$(EXECUTABLE): $(TARGET)/main.o | $(TARGET)/lib$(PROJECT).dylib
	@$(CLANG) -arch x86_64 $(ISYSROOT) -L$(TARGET) -F$(TARGET) $(MMACOSX_VERSION_MIN) -fobjc-arc \
		-framework Foundation \
		-framework $(PROJECT)Kit \
		-o $@ $(TARGET)/main.o  

test: $(TARGET)/$(EXECUTABLE)
	DYLD_FRAMEWORK_PATH=$(TARGET) $^ a a aa aaa
	DYLD_FRAMEWORK_PATH=$(TARGET) $^ aa aa aaa aaaa aabaa
	DYLD_FRAMEWORK_PATH=$(TARGET) $^ aab aab aabaab
	DYLD_FRAMEWORK_PATH=$(TARGET) $^ aabb aabb abab baba bbaa aabbaabb aabbcaabb
	DYLD_FRAMEWORK_PATH=$(TARGET) $^ Anna Anna aNna anNa annA ann AnnaHaro

cleanmake:
	@rm -rf target
	@make

$(TARGET):
	@mkdir $@

$(TARGET)/$(KIT).framework: | $(TARGET)
	@mkdir $@; cd $@; ln -s Versions/Current/$(KIT) .

$(TARGET)/$(KIT).framework/Versions: | $(TARGET)/$(KIT).framework
	@mkdir $@; cd $@; ln -s A Current

$(TARGET)/lib$(PROJECT).dylib: | $(TARGET)/$(KIT).framework/Versions/A/$(KIT)
	@cd $(TARGET); ln -s $(KIT).framework/$(KIT) lib$(PROJECT).dylib

$(TARGET)/$(KIT).framework/Versions/A: | $(TARGET)/$(KIT).framework/Versions $(TARGET)/lib$(PROJECT).dylib
	@mkdir -p $@

$(TARGET)/$(KIT).framework/Versions/A/$(KIT): $(TARGET)/$(PROJECT).o | $(TARGET)/$(KIT).framework/Versions/A
	@$(CLANG) -dynamiclib -arch x86_64 $(ISYSROOT) -L$(TARGET) -F$(TARGET) \
		$(MMACOSX_VERSION_MIN) -fobjc-arc -single_module -compatibility_version 1 -current_version 1 \
		-framework Cocoa \
		-include src/main/resources/$(PROJECT)-Prefix.pch \
		-Isrc/main/h \
		-install_name /Library/Frameworks/$(KIT).framework/Versions/A/$(KIT) \
		-o $@ \
		$^

$(TARGET)/lib%.a: $(TARGET)/%.o | $(TARGET)
	@$(LIBTOOL) -static -arch_only x86_64 $(SYSLIBROOT) -L$(TARGET) -framework Cocoa \
		-o $@ \
		$^

$(TARGET)/%.o: src/main/m/%.m | $(TARGET)
	@$(CLANG) -x objective-c -arch x86_64 -fmessage-length=0 -std=gnu99 -fobjc-arc -fpascal-strings \
		-O0 -DDEBUG=1 -fasm-blocks $(MMACOSX_VERSION_MIN) -g -Ftarget \
		"-DIBOutlet=__attribute__((iboutlet))" \
		"-DIBOutletCollection(ClassName)=__attribute__((iboutletcollection(ClassName)))" \
		"-DIBAction=void)__attribute__((ibaction)" \
		$(ISYSROOT) \
		-include src/main/resources/$(PROJECT)-Prefix.pch \
		-Isrc/main/h \
		-Wno-conversion \
		-Wno-missing-field-initializers \
		-Wno-missing-prototypes \
		-Wno-sign-conversion \
		-Wno-trigraphs \
		-Wno-deprecated-implementations \
		-Wno-four-char-constants \
		-Wno-implicit-atomic-properties \
		-Wno-missing-braces \
		-Wno-newline-eof \
		-Wno-selector \
		-Wno-shadow \
		-Wno-sign-compare \
		-Wno-strict-selector-match \
		-Wno-undeclared-selector \
		-Wno-unknown-pragmas \
		-Wno-unused-function \
		-Wno-unused-label \
		-Wno-unused-parameter \
		-Wdeprecated-declarations \
		-Wprotocol \
		-Wreturn-type \
		-Wformat \
		-Wparentheses \
		-Wpointer-sign \
		-Wshorten-64-to-32 \
		-Wswitch \
		-Wuninitialized \
		-Wunused-value \
		-Wunused-variable \
		-c $^ \
		-o $@

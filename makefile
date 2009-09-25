CCC=gcc-4.2
CCFLAGS=-I /usr/include/GNUstep/ -L /usr/lib/GNUstep/ -lgnustep-base -fconstant-string-class=NSConstantString
SOURCES=src/main.m src/Test.m 
OBJECTS=src/main.o src/Test.o
EXECUTABLE=out

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CCC) -o $@ $(OBJECTS) $(CCFLAGS)

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)

%.o : %.m
	$(CCC) $(CCFLAGS) -o $@ $^

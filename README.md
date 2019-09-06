chipKIT Board Definition Generator
==================================

This is a rudamentary Perl script for generating board definition files for chipKIT board.

It takes a "def" file describing the board and spits out the Board_Data.c and Board_Defs.h files
corresponding to that definition.

Definition file format
----------------------

The definition is simply a header detailing which chip the board uses, and the name of the board.
Following that is a list of the board pins.

The header is a pair of comments formatted thus:

    # Chip: pic32mz2048efg064
    # Name: chipKT MZ Lite

Any other comments are ignored.

Each list of pins must always start with the PIC32 internal pin name `RXnn`.  It is then followed
by a list of functions that the pin will be used for.  Supported functions are:

* UART Serial TX and RX
* SPI SCK, SDI, SDO and SS
* I2C SDA and SCL
* Interrupt pins
* PWM
* Analog inputs
* LEDs
* Buttons

Any other macros names beginning with PIN_ can also be specified.

The general format for a pin function takes one of two formats.  For simple functions like PWM and interrupts
the format is simply the name of the function, such as `INT3` or `OC2` or `LED1`.

For more complex peripherals (especially serial ones) the format takes two parts.  For example `S0TX3` is made up 
of `S0` which maps the function to the "Zero-th" serial object, in this case `Serial` (or `Serial0` if USB is enabled) 
and assigns the `TX` pin of UART 3.

Some more examples:

* `S1SDI2` - Assign the SDI pin of SPI channel 2 to the DSPI1 object
* `S2SCL3` - Assign the SCL pin of I2C channel 3 to the DTWI2 object

A full example of a pin with many possible functions is as follows:

    RD3         S1SCL3      OC7                 PIN_D10                     S1TX5

Pin RD3 is defined as the clock pin for DTWI1, using I2C 3, it is PWM, it has the macro `PIN_D10` available to users, and it is the
TX pin of `Serial1`, which uses UART 5.

The full list of functions is:

    # I2C:
    SxSCLy
    SxSDAy

    # SPI:
    SxSCKy
    SxSDIy
    SxSDOy
    SxSSy

    # UART
    SxTXy
    SxRXy

    # LEDs and buttons
    LEDx
    BTNx

    # Interrupts
    INTx

    # PWM
    OCx

    # Analog inputs
    Ax

See the included example files for more, um, examples.

Extending the script
--------------------
 
Only a few chips are supported at the moment.  Chips are added by creating a new chip definition file for the chip.  The file
consists of four basic sections:

1. Family information - Simply if it's an MX or MZ chip.
2. Pin definitions - these list what hard-wired functions a pin has, and is a direct copy of the pin information from the datasheet
3. Input mappings - lists the relationships between pins and input functions
4. Output mappins - lists the relationships between pins and output functions

Configuration files are looked for in different locations (in order of precedence):

    $HOME/.local/share/mkdef
    /usr/local/share/mkdef
    /usr/share/mkdef

The family information is either:

    family mx

or

    family mz

and defines how to build the resultant files.

A pin definition starts with the word "pin" and contains the list of functions separated by `/` just as they are in
the datasheet.  For example:

    pin CVREFOUT/AN10/C3INB/RPB14/VBUSON/SCK1/CTED5/RB14

Input and Output mappings are prefixed with `inmap` and `outmap` respectively, and each is made up of two lists of items
formatted similar to the pin definitions.  The first portion of the definition is the list of pins in the particular input
or output group. The second portion is the list of functions within that group.

For example:

    inmap RPA0/RPB3/RPB4/RPB15/RPB7 INT4/T2CK/IC4/SS1/REFCLKI

Or:

    outmap RPA2/RPB6/RPA4/RPB13/RPB2 SDO1/SDO2/OC4/OC5/REFCLKO

These names, again, are taken directly from the datasheet.

The board definition files themselves also contain a pre- and post-amble which is taken directly from family-specific 
files named `data-preample-mx.txt`, `defs-postamble-mz.txt` etc.

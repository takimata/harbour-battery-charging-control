#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char *argv[]) {
    ofstream chargeControlFile;
    chargeControlFile.open("/sys/class/power_supply/battery/battery_charging_enabled", ios::out | ios::trunc );

    chargeControlFile << "0" << endl;
    chargeControlFile.close();
    return 0;
}

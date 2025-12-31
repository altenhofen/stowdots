#!/bin/sh

curl -s "https://get.sdkman.io" | bash
sdkman install java 17.0.9-tem
sdkman install java 21.0.5-tem
sdk default java21.0.5-tem

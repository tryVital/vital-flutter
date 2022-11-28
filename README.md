# vital_flutter

This package is now deprecated. 
To improve user experience we have separated the functionality of this package into separate packages.

The new packages are:
- [vital_core][1] holds common
  components to both `vital_health` and `vital_devices`. Among other things, it has the network layer that allows us to
  send data from a device to a server.
- [vital_health][2] is an abstraction over HealthKit an Health Connect(coming soon)
- [vital_devices][3] is an abstraction over a set of Bluetooth devices.

## Documentation

For more example usage run the sample app with your API key and Region set in `main.dart`.
Please refer to the [official Vital](https://docs.tryvital.io/welcome/libraries) docs provide a full reference on using
this library.

## License

vital-flutter is available under the AGPLv3 license. See the LICENSE file for more info. VitalDevices is under
the `Adept Labs Enterprise Edition (EE) license (the “EE License”)`. Please refer to its license inside its folder.

[1]: https://pub.dev/packages/vital_core

[2]: https://pub.dev/packages/vital_health

[3]: https://pub.dev/packages/vital_devices

## 0.4.0-alpha.2
* Added pairing 
* Only request permission when the it is required

## 0.4.0-alpha.1
* Add the `DeviceManger` to manage the supported glucose and blood pressure devices.

## 0.3.4
* Correctly dispose the ios health kit plugin when the app is in the background

## 0.3.0
* **Breaking** - `UserService.getAll` return type change from
  `List<User>` to `GetAllUsersResponse`

## 0.2.1
* HealthKit - split configure method into configureClient and configureHealthkit with auto sync, logging and background
  delivery options

## 0.2.0
* Support for HealthKit

## 0.1.0
* REST Client for https://tryvital.io/

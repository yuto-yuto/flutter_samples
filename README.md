# flutter_samples

Flutter samples for my blog.

https://www.technicalfeeder.com/category/dart/

Buy Me a Coffee if you think these samples are helpful and save your time.
<a href="https://www.buymeacoffee.com/yuto" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Run on Linux Desktop

If you want to run this sample app on Linux desktop, comment out the `Firebase.initializeApp()` call in main.dart. Some pages don't work as expected but others work fine.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
```

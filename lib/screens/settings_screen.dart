import 'dart:developer';
import '../../index.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  XFile _image;
  var _imagePicker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: _actions(),
      ),
      body: _forms(),
    );
  }

  List<Widget> _actions() {
    return [
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () => _submit(),
      ),
    ];
  }

  Widget _forms() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Logo company",
                textAlign: TextAlign.left,
              ),
              _viewPhotoSelection(),
              SizedBox(height: 10.0),
              _nameField(),
              SizedBox(height: 10.0),
              _adressField(),
              SizedBox(height: 30.0),
              Text(
                "Offline settings - Pdf",
                textAlign: TextAlign.left,
              ),
              Divider(),
              SizedBox(height: 10.0),
              _changeSta("QrCode"),
              SizedBox(height: 10.0),
              _changeSta("Titel"),
              SizedBox(height: 10.0),
              _changeSta("Logo"),
              SizedBox(height: 10.0),
              _changeSta("Footer"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeSta(String titelSet) {
    return SwitchListTile(
      title: Text(titelSet),
      value: prefs.getBool(titelSet) ?? true,
      onChanged: (bool value) {
        setState(() {
          prefs.setBool(titelSet, value);
        });
      },
      secondary: const Icon(Icons.settings),
    );
  }

  Widget _nameField() {
    log('${company.name}');
    return TextFormField(
      initialValue: '${company.name}',
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      onSaved: (value) => company.name = value,
    );
  }

  Widget _adressField() {
    return TextFormField(
      initialValue: '${company.adress}',
      decoration: InputDecoration(
        labelText: 'Adress',
      ),
      onSaved: (value) => company.adress = value,
    );
  }

  Widget _viewPhotoSelection() {
    return GestureDetector(
      onTap: () {
        _getPhoto(ImageSource.gallery);
      },
      child: _viewPhoto(),
    );
  }

  Widget _viewPhoto() {
    //log(company.logoUrl);
    if (company.logoUrl != null) {
      return FadeInImage(
        image: NetworkImage(company.logoUrl),
        placeholder: AssetImage(circularProgressIndicatorSmall),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      if (_image != null) {
        return Container(
          child: kIsWeb
              ? Image.network(_image.path)
              : Image.file(
                  File(_image.path),
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
        );
      } else {
        return Container(
          child: Image.asset(
            'assets/img/image-placeholder.jpg',
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }

  void _getPhoto(final ImageSource source) async {
    _imagePicker = new ImagePicker();
    XFile pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);

    if (pickedFile != null) {
      print("-------------- " + pickedFile.path);

      company.logoUrl = null;
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    print(_image);
    if (_image != null) {
      final url = await companyProvider.uploadFile(_image);
      if (url != null) {
        company.logoUrl = url;
      }
    }
  }

  Widget _saveButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
      icon: Icon(Icons.save),
      label: Text('Save'),
      //onPressed: _saving ? null : _submit,
    );
  }

  void _submit() async {
    final valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    _formKey.currentState.save();
    setState(() {});

    await _uploadPhoto();
    if (company.id == null) {
      _saveProduct();
    } else {
      _updateProduct();
    }
  }

  void _saveProduct() async {
    final saved = await companyProvider.addCompany(company: company);
    final message = saved ? 'New settings saved' : 'Error to save the product';
    _viewAlert(message, saved ? Colors.green : Colors.red);

    _navigateBack(saved);
  }

  void _updateProduct() async {
    final updated = await companyProvider.updateCompany(company: company);
    final message =
        updated ? 'Settings updated' : 'Error to update the product';
    _viewAlert(message, updated ? Colors.green : Colors.red);
    _navigateBack(updated);
  }

  void _viewAlert(final String message, final Color color) {
    final snackbar = SnackBar(
      backgroundColor: color,
      content: Text('$message'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _navigateBack(final bool navigate) {
    if (navigate) {
      Future.delayed(
        Duration(milliseconds: 1500),
        () => Navigator.pop(context),
      );
    }
  }
}

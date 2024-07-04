import 'package:flutter/material.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KeyPair? keyPair;
  String? result;

  @override
  void initState() {
    super.initState();
    initKeypair();
  }

  Future<void> initKeypair() async {
    Wallet wallet = await Wallet.from(
        'manage dilemma chalk burden evidence prefer toilet icon wine horse trust tortoise');
    final pair = await wallet.getKeyPair();
    setState(() {
      keyPair = pair;
    });
  }

  Future<void> _establishTrustline() async {
    final stellarSDK = StellarSDK.PUBLIC;
    final asset = Asset.createNonNativeAsset(
        'USDC', 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN');

    AccountResponse account =
        await stellarSDK.accounts.account(keyPair!.accountId);

    Transaction transaction = TransactionBuilder(account)
        .addOperation(
            ChangeTrustOperationBuilder(asset, '922337203685.4775807').build())
        .build();

    transaction.sign(keyPair!, Network.PUBLIC);

    SubmitTransactionResponse response =
        await stellarSDK.submitTransaction(transaction);

    setState(() {
      result = response.envelopeXdr;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: keyPair == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Tap on Establish Trustline, check console, copy output to https://laboratory.stellar.org/',
                  ),
                  FilledButton.icon(
                      label: const Text("Establish Trustline"),
                      onPressed: () async => {await _establishTrustline()}),
                  result == null ? const Text('waiting fo tap') : Text(result!)
                ],
              ),
            ),
    );
  }
}

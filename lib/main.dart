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
  Future<void> _establishTrustline() async {
    final stellarSDK = StellarSDK.TESTNET;

    final keyPair = KeyPair.random();
    final asset = Asset.createNonNativeAsset(
        'ASILVER', 'GD3TLZTXQR3UTJ5L76QIG3JXEO4USOCC5XNUTAHY5SYE7AT2FAXM5XPL');

    await FriendBot.fundTestAccount(keyPair.accountId);

    AccountResponse account =
        await stellarSDK.accounts.account(keyPair.accountId);

    Transaction transaction = TransactionBuilder(account)
        .addOperation(
            ChangeTrustOperationBuilder(asset, '922337203685.4775807').build())
        .build();

    transaction.sign(keyPair, Network.TESTNET);

    SubmitTransactionResponse response =
        await stellarSDK.submitTransaction(transaction);

    print(response.envelopeXdr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tap on Establish Trustline, check console, copy output to https://laboratory.stellar.org/',
            ),
            FilledButton.icon(
                label: const Text("Establish Trustline"),
                onPressed: () async => {await _establishTrustline()})
          ],
        ),
      ),
    );
  }
}

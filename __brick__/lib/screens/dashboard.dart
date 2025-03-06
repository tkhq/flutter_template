import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Wallet? _selectedWallet;
  WalletAccount? _selectedAccount;

  @override
  void initState() {
    super.initState();
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);
    turnkeyProvider.addListener(_updateSelectedWallet);
    _updateSelectedWallet();
  }

  void _updateSelectedWallet() {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    if (turnkeyProvider.session?.user != null &&
        turnkeyProvider.session!.user!.wallets.isNotEmpty) {
      setState(() {
        _selectedWallet = turnkeyProvider.session?.user!.wallets[0];
        _selectedAccount =
            turnkeyProvider.session?.user!.wallets[0].accounts[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<TurnkeyProvider>(context, listen: false)
                .clearAllSessions();
          },
          icon: Icon(
            Icons.logout,
            size: 24.0,
          ),
        ),
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Consumer<TurnkeyProvider>(
          builder: (context, turnkeyProvider, child) {
            final user = turnkeyProvider.session?.user;
            final userName =
                (user?.userName != null && user!.userName!.isNotEmpty)
                    ? user.userName
                    : 'N/A';

            final walletAccounts = _selectedWallet?.accounts;

            return Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You are successfully authenticated with Turnkey!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'OrgId:${user?.organizationId} \nUserId: ${user?.id} \nUserName: $userName',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

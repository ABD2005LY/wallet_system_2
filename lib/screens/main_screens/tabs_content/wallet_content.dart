import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:wallet_system_2/helpers/consts.dart';
import 'package:wallet_system_2/helpers/functions_helper.dart';
import 'package:wallet_system_2/models/wallet_model.dart';
import 'package:wallet_system_2/providers/auth_provider.dart';
import 'package:wallet_system_2/widgets/statics/shimmer_widget.dart';

class WalletContent extends StatefulWidget {
  const WalletContent({super.key});

  @override
  State<WalletContent> createState() => _WalletContentState();
}

class _WalletContentState extends State<WalletContent> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authConsumer, _) {
        return SafeArea(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: 300.ms,
                child: authConsumer.busy || authConsumer.walletModel == null
                    ? SizedBox(
                        height: getSize(context).height * 0.24,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ShimmerWidget(),
                        ),
                      )
                    : DigitalCard(walletModel: authConsumer.walletModel!),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DigitalCard extends StatelessWidget {
  const DigitalCard({super.key, required this.walletModel});
  final WalletModel walletModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
        
              borderRadius: BorderRadius.circular(16),
            ),
        
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/chip.png",
                        width: getSize(context).width * 0.15,
                      ),
        
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          walletModel.name,
                          style: labelMedium.copyWith(color: whiteColor),
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 70),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTime.now()
                            .add(Duration(days: 365))
                            .toString()
                            .substring(2, 7)
                            .replaceAll("-", "/"),
                        style: labelMedium.copyWith(color: whiteColor),
                      ),
        
                      Text(
                        "${walletModel.balance} LYD",
                        style: labelMedium.copyWith(color: whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
          ),
          
        ),
      ],
    );
    
  }
}

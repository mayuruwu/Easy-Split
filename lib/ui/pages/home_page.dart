import 'package:flutter/material.dart';

//packages
import 'package:easy_split/ui/cwidgets/balance_card.dart';
import 'package:easy_split/ui/cwidgets/summary_card.dart';
import 'package:easy_split/ui/cwidgets/activity_tile.dart';
import 'package:easy_split/ui/cwidgets/bottom_nav.dart';
import 'package:easy_split/ui/elements/app_bar.dart';

import 'package:go_router/go_router.dart';

//bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_split/bloc/Auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myAppBar(
        title: "Easy Split",
        actions: [
          IconButton(
            onPressed: () {
              context.push('/home/add_group');
            },
            icon: const Icon(Icons.group_add),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Top Bar
              const SizedBox(height: 20),

              /// Balance
              const BalanceCard(),

              const SizedBox(height: 20),

              /// Summary
              Row(
                children: const [
                  Expanded(
                    child: SummaryCard(
                      title: "You are owed",
                      amount: "\$2,450.00",
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SummaryCard(
                      title: "You owe",
                      amount: "\$1,209.50",
                      isPositive: false,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("+ Add Expense"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// List
              Expanded(
                child: ListView(
                  children: const [
                    ActivityTile(
                      title: "Dinner at The Foundry",
                      subtitle: "Added by Alex",
                      amount: "+\$22.00",
                      positive: true,
                    ),
                    ActivityTile(
                      title: "Electricity Bill",
                      subtitle: "Added by Marcus",
                      amount: "-\$70.11",
                      positive: false,
                    ),
                    ActivityTile(
                      title: "Shared Groceries",
                      subtitle: "Added by Emma",
                      amount: "Not involved",
                      positive: null,
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogOut());
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

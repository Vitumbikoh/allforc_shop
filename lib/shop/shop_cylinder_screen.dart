import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/models.dart';
import 'shop_cylinder_form.dart';
import 'customer_cylinder_form.dart';
import 'gas_fill_dao.dart';

class ShopCylinderScreen extends StatefulWidget {
  const ShopCylinderScreen({super.key});

  @override
  State<ShopCylinderScreen> createState() => _ShopCylinderScreenState();
}

class _ShopCylinderScreenState extends State<ShopCylinderScreen> {
  final GasFillDao _dao = GasFillDao();

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Gas Refilling',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: FutureBuilder<List<ShopCylinder>>(
        future: _dao.getShopCylinders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No cylinders available.'));
          } else {
            final shopCylinders = snapshot.data!;
            return ListView.builder(
              itemCount: shopCylinders.length,
              itemBuilder: (context, index) {
                final shopCylinder = shopCylinders[index];
                final progress = shopCylinder.openingMass != 0
                    ? shopCylinder.gasAmount / shopCylinder.openingMass
                    : 0.0;

                // Calculate the fixed total mass and the changing total mass
                final fixedTotalMass =
                    shopCylinder.tareMass + shopCylinder.openingMass;
                final gasRemained =
                    shopCylinder.tareMass + shopCylinder.gasAmount;

                return Card(
                  margin: EdgeInsets.all(8.w),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          shopCylinder.cylinderName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Opening Mass: $fixedTotalMass kg',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Remained Total Mass: $gasRemained kg',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 8.h,
                                top: 8.h,
                              ),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                value: progress,
                                minHeight: 10.h,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gas Amount: ${shopCylinder.gasAmount} kg',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          _deleteShopCylinder(shopCylinder),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _showCustomerCylinderForm(
                                              context, shopCylinder),
                                      child: Text(
                                        'Refill Gas',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<CustomerCylinder>>(
                        future: _dao.getCustomerCylinders(shopCylinder.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const SizedBox(); // Empty container if no data
                          } else {
                            final customerCylinders = snapshot.data!;
                            return Column(
                              children: [
                                const Divider(),
                                Text(
                                  'Customer Cylinders Refilled:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: customerCylinders.length,
                                  itemBuilder: (context, index) {
                                    final customerCylinder =
                                        customerCylinders[index];
                                    return Card(
                                      color: Colors.orange,
                                      margin: EdgeInsets.only(
                                        bottom: 10.h,
                                        left: 5.w,
                                        right: 5.w,
                                        top: 5.h,
                                      ),
                                      child: ListTile(
                                          title: Text(
                                            'Customer Cylinder ID: ${customerCylinder.id}',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total Mass: ${customerCylinder.totalMass} kg',
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Gas Refilled: ${customerCylinder.gasAmount} kg',
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShopCylinderForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddShopCylinderForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddShopCylinderForm(onAdd: _refreshData),
      ),
    );
  }

  _showCustomerCylinderForm(
    context,
    shopCylinder,
  ) {
    _dao.getShopCylinders().then((shopCylinders) {
      final cylinder = shopCylinders
          .firstWhere((cylinder) => cylinder.id == shopCylinder.id);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CustomerCylinderForm(
          shopCylinder,
          cylinder.cylinderName, // Pass cylinderName here
          onUpdate: _refreshData,
        ),
      );
    });
  }

  Future<void> _deleteShopCylinder(ShopCylinder shopCylinder) async {
    await _dao.deleteShopCylinder(shopCylinder.id!);
    _refreshData();
  }
}

import 'package:flutter/material.dart';
import 'package:supreox_skill_test/const/colors.dart';
import 'package:supreox_skill_test/models/products_model.dart';
import 'package:supreox_skill_test/network/presenter.dart';
import 'package:supreox_skill_test/widgets/dash_painter.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _isInit = true;
  List<Menu> productList = [];
  double subtotal = 0.0;
  Map<int, int> productQuantities = {};

  @override
  void initState() {
    if (_isInit) {
      _callProductListApi();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height / 1.4,
              decoration: BoxDecoration(
                color: AppColors.listBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFF6B23),
                          Color(0xffFF9727),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Breakfast",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "vat(5%) Service Charge(5%)",
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          Image.asset("assets/icons/Vector.png"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return _buildProductListItem(productList[index], index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Future<void> _callProductListApi() async {
    try {
      List<ProductsModel> productListModel = [];

      var productListInfo = await initProductListInfo(context);

      if (productListInfo is String) {
        // Error Message
      } else {
        productListModel.add(productListInfo);
        productList.addAll(productListModel.elementAt(0).menu);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void _updateSummary(int productId, int price, int change) {
    setState(() {
      if (productQuantities.containsKey(productId)) {
        productQuantities[productId] = productQuantities[productId]! + change;
      } else {
        productQuantities[productId] = 1;
      }

      subtotal += price * change;
    });
  }

  Widget _buildProductListItem(Menu product, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CustomPaint(
                painter: DashPainter(color: Colors.deepOrange.shade200, radius: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                    color: AppColors.summaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(product.image),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: AppColors.titleColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 10, color: AppColors.descriptionColor),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("\$${product.price}"),
                  SizedBox(height: 3),
                  productQuantities.containsKey(index) && productQuantities[index]! > 0
                      ? _buildQuantityControls(product, index)
                      : InkWell(
                    onTap: () {
                      _updateSummary(index, product.price, 1);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      // height: 25,
                      // width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.8, color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(fontSize: 11),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildDottedDivider(),
      ],
    );
  }

  Widget _buildQuantityControls(Menu product, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 0.8, color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _updateSummary(index, product.price, -1);
            },
            child: Icon(Icons.remove, size: 16, color: Colors.black),
          ),
          SizedBox(width: 8),
          Text(productQuantities[index].toString()),
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              _updateSummary(index, product.price, 1);
            },
            child: Icon(Icons.add, size: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(150 ~/ 2, (index) {
          return Container(
            width: 2,
            height: 1,
            color: Colors.deepOrange,
            margin: EdgeInsets.symmetric(horizontal: 0),
          );
        }),
      ),
    );
  }

  Widget _buildSummarySection() {
    double vat = subtotal * 0.05;
    double total = subtotal + vat;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.summaryColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotal', subtotal, false),
          SizedBox(height: 10,),
          _buildSummaryRow('Vat(5%) Service Charge included (5%)', vat, true),
          SizedBox(height: 10,),
          Divider(color: AppColors.totalColor,height: 2,),
          _buildSummaryRow('Total', total, false),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, bool isVat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isVat?TextStyle(fontSize: 12,color:  AppColors.vatColor):TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isVat?TextStyle(fontSize: 16,color:  AppColors.vatColor, fontWeight: FontWeight.bold):TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppColors.totalColor),
          ),
        ],
      ),
    );
  }
}

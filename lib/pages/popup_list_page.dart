import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_poppin/component/store_list_widget.dart';
import 'package:project_poppin/controller/store_controller.dart';
import 'package:project_poppin/theme/colors.dart';

class PopUpListPage extends StatefulWidget {
  const PopUpListPage({super.key});

  @override
  State<PopUpListPage> createState() => _PopUpListPageState();
}

class _PopUpListPageState extends State<PopUpListPage>
    with AutomaticKeepAliveClientMixin {
  String locationName = Get.arguments;
  StoreController storeControllerManager = Get.find();
  final ScrollController _scrollController = ScrollController();

  final updateBasketThrottle = Throttle(
    const Duration(milliseconds: 1000),
    initialValue: null,
    checkEquality: false,
  );

  var lastPopTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);

    updateBasketThrottle.values.listen((event){

      storeControllerManager.setLoadDataStateCheck(true);

      storeControllerManager.getStoreListLocationFilter(
          storeControllerManager.storeLocationState,
          locationName.split("/"),
          false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<StoreController>(builder: (storeController) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 28,
                    margin: const EdgeInsets.only(left: 4),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 23,
                        )),
                  ),
                  Flexible(
                      child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text:
                            locationName == "중구/명동/중" ? "중구/명동" : locationName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: poppinColorGreen500,
                            fontSize: 13)),
                    const TextSpan(
                        text: " 에서 열리는 팝업들",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 13))
                  ]))),
                  const SizedBox(
                    width: 32,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            storeController.storeFilterLocationList.isEmpty
                ? storeController.localListDataLoadStateEmpty
                    ? const Center(
                        child: Text(
                          "진행중인 팝업이 없습니다",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                      )
                    : const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                        itemCount:
                            storeController.storeFilterLocationList.length +
                                (storeController.loadDataState ? 1 : 0),
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        itemBuilder: (context, index) {
                          if (index ==
                              storeController.storeFilterLocationList.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return StoreListWidget(
                            storeData:
                                storeController.storeFilterLocationList[index],
                            index: index,
                            storeController: storeController,
                            currentPage: 'popup_list_page',
                          );
                        }))
          ],
        ),
      );
    });
  }

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      updateBasketThrottle.setValue(null);

    }
  }
  
}

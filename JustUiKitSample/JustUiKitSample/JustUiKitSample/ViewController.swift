//
//  ViewController.swift
//  JustUiKitSample
//
//  Created by 刘丰恺 on 2017/2/6.
//  Copyright (c) 2017 ___lfkdsk___. All rights reserved.
//

import UIKit
import JustUiKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSectionLabel(_ title: String) -> UILabel {
        let sectionLabel = UILabel()
        sectionLabel.text = title;
        sectionLabel.font = UIFont.systemFont(ofSize: 17)
        sectionLabel.sizeToFit()
        sectionLabel.backgroundColor = UIColor.brown
        // sizeToFit函数的意思是让视图的尺寸刚好包裹其内容。
        // 注意sizeToFit方法必要在设置字体、文字后调用才正确。
        return sectionLabel
    }

    func loadLinearLayout() {
        self.view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(rgb: 0xFF8C00)

        let lfkdsk = JustLinearLayout(frame: UIScreen.main.bounds, orientation: .Horizontal)

        view.addSubview(lfkdsk)

        let linearLayout: JustLinearLayout = lfkdsk

        let params: LinearLayoutParams = LinearLayoutParams(
                width: LayoutParams.WRAP_CONTENT,
                height: LayoutParams.WRAP_CONTENT)
        params.weight = 1
//        params.leftMargin = 100
//        params.rightMargin = 10

        let fuckView = createSectionLabel("FUCK")

        print(fuckView.frame.origin)
        print(fuckView.frame.size)

        print("Before Layout")

        let centerParams = LinearLayoutParams(linear: params)
//        centerParams.weight = 1
        centerParams.layoutGravity = Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL

        let rightParams = LinearLayoutParams(linear: params)
        rightParams.layoutGravity = Gravity.BOTTOM

        let rightAndBottomParams = LinearLayoutParams(params)
//        rightAndBottomParams.weight = 1
        rightAndBottomParams.layoutGravity = Gravity.BOTTOM | Gravity.RIGHT

        let rightAndTopParams = LinearLayoutParams(linear: params)
//        rightAndTopParams.rightMargin = 12
//        rightAndTopParams.weight = 1
        rightAndTopParams.layoutGravity = Gravity.TOP | Gravity.RIGHT

        linearLayout.addView(view: createSectionLabel("苟"), params: rightAndTopParams)
        linearLayout.addView(view: createSectionLabel("利"), params: params)
        linearLayout.addView(view: createSectionLabel("国"), params: params)
//        linearLayout.addView(view: createSectionLabel("家"), params: centerParams)
//        linearLayout.addView(view: createSectionLabel("生"), params: params)
//        linearLayout.addView(view: createSectionLabel("死"), params: rightAndBottomParams)
//        linearLayout.addView(view: createSectionLabel("以"), params: params)
//        linearLayout.addView(view: createSectionLabel("岂因祸福"), params: params)
//        linearLayout.addView(view: createSectionLabel("岂因祸福"), params: params)
//        linearLayout.addView(view: createSectionLabel("岂因祸福"), params: params)
//        linearLayout.addView(view: createSectionLabel("以"), params: params)

        var fuck2View = JustLinearLayout(orientation: .Horizontal)
//        fuck2View.linearExtension.padding.paddingBottom = 10
        var Fuck2Params = LinearLayoutParams(width: LayoutParams.MATCH_PARENT,
                height: LayoutParams.WRAP_CONTENT)
//        Fuck2Params.topMargin = 80
        Fuck2Params.leftMargin = 20
        Fuck2Params.weight = 1
        Fuck2Params.layoutGravity = Gravity.CENTER_VERTICAL
//        fuck2View.setPadding(top: 10, left: 0, right: 10, bottom: 0)
        lfkdsk.addView(view: fuck2View, params: Fuck2Params)

        let firstInnerItem = createSectionLabel("以")
//        rightAndTopParams.bottomMargin = 10

        fuck2View.addView(view: firstInnerItem, params: params)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: params)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: params)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: params)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: rightParams)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: params)
        fuck2View.addView(view: createSectionLabel("岂因祸福"), params: centerParams)
//        fuck2View.linearExtension.padding.paddingRight = 80

    }

    func loadFrameLayout() {
        self.view = JustFrameLayout(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(rgb: 0xFF8C00)

        let lfkdsk: JustFrameLayout = view as! JustFrameLayout
//        (view as! JustFrameLayout).addView(view: lfkdsk, params: FrameLayoutParams(width:
//        LayoutParams.WRAP_CONTENT, height: LayoutParams.WRAP_CONTENT))

        let params = FrameLayoutParams(width: LayoutParams.WRAP_CONTENT,
                height: LayoutParams.WRAP_CONTENT)

        let CENTER_V = FrameLayoutParams(source: params)
        CENTER_V.layoutGravity = Gravity.CENTER_HORIZONTAL

        let CENTER_H = FrameLayoutParams(source: params)
        CENTER_H.layoutGravity = Gravity.CENTER_VERTICAL

        let bottom_left = FrameLayoutParams(source: params)
        bottom_left.layoutGravity = Gravity.BOTTOM | Gravity.LEFT

        let ver_right = FrameLayoutParams(source: params)
        ver_right.layoutGravity = Gravity.CENTER_VERTICAL | Gravity.RIGHT

        let center = FrameLayoutParams(source: params)
        center.layoutGravity = Gravity.CENTER

        lfkdsk.addView(view: createSectionLabel("FFFFFFFFFF"), params: CENTER_V)
        lfkdsk.addView(view: createSectionLabel("ssssssss"), params: CENTER_H)
        lfkdsk.addView(view: createSectionLabel("aaaaa"), params: bottom_left)
        lfkdsk.addView(view: createSectionLabel("vvvv"), params: ver_right)
        lfkdsk.addView(view: createSectionLabel("ssss"), params: center)
    }

    func loadRelativeLayout() {
        self.view = JustRelativeLayout(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(rgb: 0xFF8C00)

        let lfkdsk: JustRelativeLayout = view as! JustRelativeLayout

        let params = JustRelativeLayout(width: LayoutParams.WRAP_CONTENT,
                height: LayoutParams.WRAP_CONTENT)

        let view1 = createSectionLabel("FFF")


    }

    func addViewToLayout() {
        self.view = JustRelativeLayout(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(rgb: 0xFF8C00)

        let lfkdsk: JustFrameLayout = view as! JustFrameLayout

        let view1 = createSectionLabel("FFFFFFFFFFF__________")
        lfkdsk.addView(view: view1)
    }

    override func loadView() {
        super.loadView()

//        loadFrameLayout()
        addViewToLayout()
    }

}

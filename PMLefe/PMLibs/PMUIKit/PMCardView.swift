//
//  PMCardView.swift
//  PMLefe
//
//  Created by wsy on 16/4/21.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit

enum PMCardType: Int {
    case Album
    case Video
    case Audio
    case Note
}

struct PMCard {
    var type: PMCardType
    var data: AnyObject
}

private let kMaxCells = 4
private let kCellPadding = 10 // cell间的距离
private let kCardEdge: CGFloat = 20 // card 的边界
private let kCellBottomHeight: CGFloat = 60 // cell底部时间的高度
private let kFlyButtonWidth: CGFloat = 80 // fly按钮宽度
private let kCellContentPadding: CGFloat = 10 // 内容填充
private let kSliderTimeInteval: NSTimeInterval = 0.8 // 内容填充
private let kCellTagOffset = 123430

protocol PMCardCellDelegate{
    
    func cardCellBeginDrag(cell: PMCardCell)
    func cardCellDraging(cell: PMCardCell)
    func cardCellEndDrag(cell: PMCardCell)
    func cardCellCancelDrag(cell: PMCardCell)
}

// The card cell
class PMCardCell: UIImageView {
    // 背景视图
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: "ls_cardBg")
        return imageView
    }()
    
    // 主要的背景视图
    lazy var bgView: UIView = {
        let imageView = UIView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .Center
        label.textColor = PMUIContraint.defaultNoteTextColor()
        return label
    }()
    
    // 飞
    lazy var flyButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "ls_fly"), forState: .Normal)
        button.addTarget(self, action: #selector(PMCardCell.flyClick(_:)), forControlEvents: .TouchUpInside)
        return button
    }()

    // 相册
    lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    // 标题
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name: PMUIContraint.kFontHWFangsong, size: 22)
        return label
    }()
    
    // 内容
    lazy var contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = PMUIContraint.defaultNoteTextColor()
        label.font = UIFont(name: PMUIContraint.kFontHWFangsong, size: 18)
        return label
    }()
    
    // 顶部的线
    lazy var lineTopView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ls_ine")
        return imageView
    }()
    
    // 底部的线
    lazy var lineBottomView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ls_ine")
        return imageView
    }()
    
    // 播放按钮
    lazy var playButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "ls_play"), forState: .Normal)
        button.addTarget(self, action: #selector(PMCardCell.playClick(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    // 进度条
    lazy var progressView: PMProcgressView = {
        let view = PMProcgressView(frame: CGRectZero)
        return view
    }()
    
    // 视频
    lazy var videoView: PMPlayerView = {
        let view = PMPlayerView(frame: CGRectZero)
        return view
    }()

    
    
    
    var delegate: PMCardCellDelegate?
    var cardType: PMCardType
    
    init(frame: CGRect, cardType: PMCardType) {
        self.cardType = cardType
        super.init(frame: frame)
        
        userInteractionEnabled = false
        backgroundColor = UIColor.clearColor()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(PMCardCell.panGestureClick(_:)))
        addGestureRecognizer(pan)
        
        addSubview(bgImageView)
        bgImageView.addSubview(bgView)
        bgImageView.addSubview(timeLabel)
        bgImageView.addSubview(flyButton)
        
        if cardType == .Album{
            bgView.addSubview(photoView)
        }
        else if cardType == .Note{
            bgView.addSubview(titleLabel)
            bgView.addSubview(contentLabel)
            bgView.addSubview(lineTopView)
            bgImageView.addSubview(lineBottomView)

        }
        else if cardType == .Audio{
            bgView.addSubview(titleLabel)
            bgView.addSubview(lineTopView)
            bgView.addSubview(playButton)
            bgView.addSubview(progressView)
        }
        else if cardType == .Video{
            bgView.addSubview(videoView)
        }
        
        timeLabel.font = PMUIContraint.kFont
        
        configureCardData(PMCard(type: .Album, data: ""))

    }
    
    func configureCardData(card: PMCard) {
        timeLabel.text = "2016-7-13 10:30"
        if cardType == .Album{
            photoView.image = UIImage(named: "2.jpg")
        }
        else if cardType == .Note{
            titleLabel.text = "美泉宫动物园"
            let detailText =  "从美泉宫进入到动物园后，首先在眼前的是树顶小路，这是一段几百米长的树顶吊桥组成的小路，位于动物园最高处，可以俯瞰全员。这座始建最古老的动物园占地面积不大，不过规划的十分合理。从美泉宫进入到动物园后，首先在眼前的是树顶小路，这是一段几百米长的树顶吊桥组成的小路，位于动物园最高处。"
            let parStyle = NSMutableParagraphStyle()
            parStyle.lineSpacing = 10
            
            let attDetailText = NSAttributedString(string: detailText, attributes: [NSFontAttributeName : UIFont(name: PMUIContraint.kFontHWFangsong, size: 18)!, NSParagraphStyleAttributeName: parStyle])
            contentLabel.attributedText = attDetailText
        }
        else if cardType == .Audio{
            titleLabel.text = "一首美妙的歌曲"
            
        }else if cardType == .Video{
            let movieURL = NSBundle.mainBundle().URLForResource("yuanfenVideo", withExtension: "mp4")!
            videoView.fileUrl = movieURL
        }

    }
    
    override func layoutSubviews() {
        bgImageView.frame = self.bounds
        bgView.frame = CGRectMake(0, 0, self.width, self.height - kFlyButtonWidth)
        timeLabel.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame), self.width - kFlyButtonWidth, kFlyButtonWidth)
        flyButton.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame), CGRectGetMinY(timeLabel.frame), kFlyButtonWidth, kFlyButtonWidth)
        
        let contentWidth = CGRectGetWidth(bgView.frame) - 2.0 * kCellContentPadding
        
        if cardType == .Album{
            photoView.frame = CGRectMake(kCellContentPadding, kCellContentPadding, contentWidth, CGRectGetHeight(bgView.frame) - 2.0 * kCellContentPadding)
        }
        else if cardType == .Note{
            titleLabel.frame = CGRectMake(kCellContentPadding, kCellContentPadding, contentWidth, 60)
            lineTopView.frame = CGRectMake(kCellContentPadding, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), 1.0)
            contentLabel.frame = CGRectMake(kCellContentPadding, CGRectGetMaxY(lineTopView.frame), CGRectGetWidth(titleLabel.frame), CGRectGetHeight(bgView.frame) - 2.0 * kCellContentPadding - 60)
            lineBottomView.frame = CGRectMake(kCellContentPadding, CGRectGetMinY(flyButton.frame), contentWidth, 1.0)

        }
        else if cardType == .Audio{
            titleLabel.frame = CGRectMake(kCellContentPadding, kCellContentPadding, contentWidth, 60)
            lineTopView.frame = CGRectMake(kCellContentPadding, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), 1.0)
            let playW: CGFloat = 80
            playButton.frame = CGRectMake((self.width - playW) / 2.0, (self.height - playW) / 2.0, playW, playW)
            progressView.frame = CGRectMake(kCellContentPadding, CGRectGetMinY(flyButton.frame) - 30, contentWidth, 30)
        }
        else if cardType == .Video{
            videoView.frame = CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame))
        }
    }
    
    func panGestureClick(panGesture: UIPanGestureRecognizer){
        let location: CGPoint =  panGesture.translationInView(self)
        
        
        if panGesture.state == .Began{
            // 开始
            self.delegate?.cardCellBeginDrag(self)
            
        }else if panGesture.state == .Changed{
            // 正在滑动
            self.x = location.x
            self.y = location.y
            self.delegate?.cardCellDraging(self)
            
        }else if panGesture.state == .Ended{
            // 滑动结束
            print("=== \(location)")

            func showAnimationIsLeft(isLeft: Bool){
                
                var isFly = false
                UIView.animateWithDuration(kSliderTimeInteval, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {[weak self] () -> Void in
                    if let weakSelf = self{
                        if abs(location.x) >= weakSelf.width / 2.0 || abs(location.y) >= weakSelf.width / 2.0{
                            weakSelf.x = isLeft ? -PMUIContraint.kScreenWidth : PMUIContraint.kScreenWidth
                            isFly = true
                        }else{
                            weakSelf.x = 0
                            weakSelf.y = 0
                        }
                    }
                    }) { (isFinsh) -> Void in
                        if isFly{
                            self.delegate?.cardCellEndDrag(self)

                        }
                }
            }
            
            if location.x < 0{
                // 左滑
                showAnimationIsLeft(true)
            }else{
                // 右滑
                showAnimationIsLeft(false)
            }
            
        }else{
            self.x = 0
            self.y = 0
            self.delegate?.cardCellCancelDrag(self)
        }
    
    }
    
    func flyClick(button: UIButton){
        UIView.animateWithDuration(0.5, animations: { [weak self]() -> Void in
            if let weakSelf = self{
                weakSelf.x = -PMUIContraint.kScreenWidth
                weakSelf.y = -PMUIContraint.kScreenHeight
            }

            }) { [weak self](_) -> Void in
                if let weakSelf = self{
                    weakSelf.delegate?.cardCellEndDrag(weakSelf)
                }
        }
        
    }
    
    func playClick(button: UIButton){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// The card main view
class PMCardView: UIView {
    
    // All cards
    var cells: [PMCardCell] = []
    
    // 第 kMaxCells－1个frame
    var lastFrame: CGRect = CGRectZero

    var bgImageView: UIImageView!
    var bgView: UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
        
        // Backgroud view
        bgView = UIView(frame: CGRectMake(kCardEdge, kCardEdge, self.width - 2*kCardEdge, self.height - 2*kCardEdge - 49 - 64 - 20))
        addSubview(bgView)
        
        // Cells
        for i in 0 ..< kMaxCells{
            var cell: PMCardCell
            if i == 0{
                cell = PMCardCell(frame: CGRectZero, cardType: .Video)
            }else if i == 1{
                cell = PMCardCell(frame: CGRectZero, cardType: .Note)

            }else{
                cell = PMCardCell(frame: CGRectZero, cardType: .Audio)

            }
            let cellFrame = CGRect(x: CGFloat(i * kCellPadding), y: CGFloat(i * kCellPadding), width: CGRectGetWidth(bgView.frame) - CGFloat((2*i) * kCellPadding), height: CGRectGetHeight(bgView.frame) - CGFloat((kMaxCells - 1) * kCellPadding))
            if i == kMaxCells - 1{
                cell.frame = lastFrame
            }else{
                cell.frame = cellFrame
                lastFrame = cellFrame
            }
            
            if i == 0{
                cell.userInteractionEnabled = true
            }else{
                cell.userInteractionEnabled = false
            }
            cell.delegate = self
            cell.tag = kCellTagOffset + i
            bgView.insertSubview(cell, atIndex: 0)
            cells.append(cell)
        }
    }
}

extension PMCardView: PMCardCellDelegate{
    func cardCellBeginDrag(cell: PMCardCell) {
        print(cell.tag)
    }
    
    func cardCellCancelDrag(cell: PMCardCell) {
        
    }
    
    func cardCellDraging(cell: PMCardCell) {
        
    }
    
    func cardCellEndDrag(cell: PMCardCell) {
        self.cells.removeFirst()
        cell.removeFromSuperview()
        
        // 创建一个新的cell
        let newCell = PMCardCell(frame: lastFrame, cardType: .Album)
        newCell.delegate = self
        bgView.insertSubview(newCell, atIndex: 0)
        self.cells.append(newCell)
        
        for i in 0 ..< kMaxCells{
            let cardCell = self.cells[i]
            if i == 0{
                cardCell.userInteractionEnabled = true
            }else{
                cardCell.userInteractionEnabled = false
            }
            let cellFrame = CGRect(x: CGFloat(i * kCellPadding), y: CGFloat(i * kCellPadding), width: CGRectGetWidth(bgView.frame) - CGFloat((2*i) * kCellPadding), height: CGRectGetHeight(bgView.frame) - CGFloat((kMaxCells - 1) * kCellPadding))
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                if i == kMaxCells-1{
                    cardCell.frame = self.lastFrame
                }else{
                    cardCell.frame = cellFrame
                }
            })
        }

    }
}

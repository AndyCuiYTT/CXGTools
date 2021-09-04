//
//  CXGFilePreviewViewController.swift
//  CXGTools
//
//  Created by CuiXg on 2021/9/3.
//

import UIKit
import QuickLook

/**
 *  文件预览
 */

public class CXGFilePreviewViewController: QLPreviewController {

    private var filesPath: [String] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 通过本地路径预览文件
    /// - Parameters:
    ///   - filePath: 文件路径
    ///   - viewController: 当前 Controller
    ///   - animated: 是有有跳转动画
    public func xfs_presentPreview(withFilePath filePath: String, presentingViewController viewController: UIViewController, animated: Bool) {
        self.filesPath = [filePath]
        viewController.present(self, animated: animated, completion: nil)
    }

    /// 通过本地路径预览文件
    /// - Parameters:
    ///   - filesPath: 本地文件路径数组
    ///   - viewController: 当前 Controller
    ///   - animated: 是有有跳转动画
    public func xfs_presentPreview(withFilesPath filesPath: [String], presentingViewController viewController: UIViewController, animated: Bool) {
        self.filesPath = filesPath
        viewController.present(self, animated: animated, completion: nil)
    }

    /// 通过文件 URL 预览
    /// - Parameters:
    ///   - fileURL: 文件 URL
    ///   - viewController: 当前 Controller
    ///   - animated: 是有有跳转动画
    public func xfs_presentPreview(withFileURL fileURL: String, presentingViewController viewController: UIViewController, animated: Bool) {
        cxg_replaceUrlToFilePath(fileURL) { filePath in
            DispatchQueue.main.async {
                self.filesPath = [filePath]
                self.reloadData()
            }
        }
        viewController.present(self, animated: animated, completion: nil)
    }

    ///  通过文件 URL 多文件预览
    /// - Parameters:
    ///   - filesURL: 文件 URL 路径数组
    ///   - viewController: 当前 Controller
    ///   - animated: 是有有跳转动画
    public func xfs_presentPreview(withFilesURL filesURL: [String], presentingViewController viewController: UIViewController, animated: Bool) {
        cxg_replaceUrlToFilePath(filesURL) { urls in
            self.filesPath = urls
            self.reloadData()
        }
        viewController.present(self, animated: animated, completion: nil)
    }


    deinit {
        print("deinit")
    }

}

extension CXGFilePreviewViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return filesPath.count
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return NSURL(fileURLWithPath: filesPath[index])
    }
}

extension CXGFilePreviewViewController {

    private func cxg_replaceUrlToFilePath(_ urlsString: [String], finish: @escaping ([String]) -> Void) {

        let lock = NSConditionLock(condition: 0)
        var _filesPath: [String] = []
        for i in 0 ..< urlsString.count {
            cxg_replaceUrlToFilePath(urlsString[i]) { url in
                lock.lock(whenCondition: i)
                _filesPath.append(url)
                DispatchQueue.main.async {
                    if i % 3 == 1 || i == urlsString.count - 1 {
                        finish(_filesPath)
                    }
                }
                lock.unlock(withCondition: i + 1)
            }
        }
    }

    /// 将 URL 地址转换为本地路径地址
    /// - Parameter urlString: 文件 URL 地址
    /// - Returns: 文件本地路径
    private func cxg_replaceUrlToFilePath(_ urlString: String, finish: @escaping (String) -> Void) {
        // 保存文件到 Temp 目录
        guard let url = URL(string: urlString) else {
            finish("")
            return
        }

        let filePath = NSTemporaryDirectory() + url.lastPathComponent
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            finish(filePath)
            return
        }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let downloadTask = session.downloadTask(with: request) { url, response, error in
            do {
                if !fileManager.fileExists(atPath: filePath) {
                    try FileManager.default.moveItem(at: url!, to: URL(fileURLWithPath: filePath))
                }
                    finish(filePath)
            } catch {
                #if DEBUG
                print(error)
                #endif
                    finish("")
            }
        }
        downloadTask.resume()
    }

}

class Qmlfmt < Formula
  desc "Command line application that formats QML files"
  homepage "https://github.com/jesperhh/qmlfmt"
  version "1.0.85"
  url "https://github.com/jesperhh/qmlfmt/archive/#{version}.tar.gz"
  sha256 "c78a79781f2499ffeadacfa3beea7752f8b7e511c45d163007aca73fbd066b2e"
  bottle do
    cellar :any
    sha256 "43e3173f6a8ab7be3814747a71f6dd1443ee045870a17f6c48df02734e2b4fad" => :mojave
    sha256 "6aaf6430e88458db8fe7d005f8a1f5c48d1517bd8e1eccf230bd90cd281e766f" => :high_sierra
    sha256 "2d8005a6cfba645fa5c160a67d437cd03e8c27a4976ee60b78d5728792ebbc23" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "qt" => :build

  resource "qt-creator" do
    url "https://github.com/qt-creator/qt-creator.git",
        :revision => "e8df914e"
  end

  def install
    resources.each do |res|
      res.stage(buildpath/res.name)
    end
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "qmlfmt"
  end

  test do
    (testpath/"test.qml").write <<~EOS
      import QtQuick 2.5
      import QtQuick.Window 2.2
      import    "qrc:/test/"

      Window {
          visible: true

          MouseArea {
              anchors.fill: parent
              onClicked: {
                  Qt.quit();
              }
          }

          Test {

          }

          Text {
              text: qsTr("Hello World")
              anchors.centerIn: parent
          }
      }
    EOS
    expected = <<~EOS
      import QtQuick 2.5
      import QtQuick.Window 2.2
      import "qrc:/test/"

      Window {
          visible: true

          MouseArea {
              anchors.fill: parent
              onClicked: {
                  Qt.quit()
              }
          }

          Test {
          }

          Text {
              text: qsTr("Hello World")
              anchors.centerIn: parent
          }
      }
    EOS

    system "#{bin}/qmlfmt", "-w", "test.qml"
    assert_equal expected, File.read("#{testpath}/test.qml")
  end
end

class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.tar.gz"
  sha256 "cd21d2a85f073e72f10900632fdcb49956985255a5711fb4f6d434433b09dac9"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    rebuild 1
    sha256 "cee80248901ba81176a134a839609e1a23f0a22c4c57e1fbedc741893917f595" => :high_sierra
    sha256 "b87c40fc9e686d2140b4b3792cd60b4e2c7025934ce26e5d8f8bcc1d5142e7b8" => :sierra
    sha256 "f9ae0a7071d23f8f38c55380874692413506334a889812c299995255bc311026" => :el_capitan
  end

  depends_on "qt"
  depends_on "tarsnap"

  def install
    # Fix "Project ERROR: Tarsnap-gui requires Qt 5.2 or higher."
    # Reported 11 Dec 2017 https://github.com/Tarsnap/tarsnap-gui/issues/171
    inreplace "Tarsnap.pro", "lessThan(QT_VERSION, 5.2)",
                             "lessThan(QT_VERSION, 5.1)"

    system "qmake"
    system "make"
    system "macdeployqt", "Tarsnap.app"
    prefix.install "Tarsnap.app"
  end

  test do
    system "#{opt_prefix}/Tarsnap.app/Contents/MacOS/Tarsnap", "--version"
  end
end

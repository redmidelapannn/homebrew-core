class FcitxRemoteForOsx < Formula
  desc "handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.1.0.tar.gz"
  sha256 "d0956fc1034561cc3722a1b3c74ef9854de90c56b05d1e2d5f5408a9ddda23f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f81b136fb33135bd821296c46677f440bcd7bf58cb3d154b7bc47db378723744" => :el_capitan
    sha256 "70c1b27156530dbbc246a42aee1aa885a1df0198c5fe8decce45404aeeea5b04" => :yosemite
    sha256 "f5d6a8d16672b5ba970246570cffe9dc67d045b3f1b6b0895ad75f734fa867e6" => :mavericks
  end

  option "with-input-method=", "Select input method: general(default), baidu-pinyin, baidu-wubi, sogou-pinyin, qq-wubi, squirrel-rime, osx-pinyin"

  def install
    input_method = ARGV.value("with-input-method") || "general"
    system "./build.py", "build", input_method
    bin.install "fcitx-remote-#{input_method}"
    bin.install_symlink "fcitx-remote-#{input_method}" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote"
  end
end

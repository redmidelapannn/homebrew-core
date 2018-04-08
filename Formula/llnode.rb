class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v1.6.3.tar.gz"
  sha256 "febf029685afbcd513250ee82dc39889ffd4c8087d9377ef17e16f17a2200bf5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5f1ca3a2f48729e7f1a8d0ad1abc972d8907d7b0e678ca84ce041619de2d265b" => :high_sierra
    sha256 "0edfeb087005dea738b501d1825600cbfae022b93c83dfea679c44f29cafddf3" => :sierra
    sha256 "9ea66112194b7c5b132ef2412bc14e15920992b7084f0c81a0f935abc30052fb" => :el_capitan
  end

  depends_on "python@2" => :build
  depends_on :macos => :yosemite

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "324dd166b7c0b39d513026fa52d6280ac6d56770"
  end

  resource "lldb" do
    if DevelopmentTools.clang_build_version >= 900
      # lldb release_40 branch tip of tree commit from 12 Jan 2017
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "fcd2aac9f179b968a20cf0231c3386dcef8a6659"
    elsif DevelopmentTools.clang_build_version >= 802
      # lldb 390
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "d556e60f02a7404b291d07cac2f27512c73bc743"
    elsif DevelopmentTools.clang_build_version >= 800
      # lldb 360.1
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "839b868e2993dcffc7fea898a1167f1cec097a82"
    else
      # It claims it to be lldb 350.0 for Xcode 7.3, but in fact it is based
      # of 34.
      # Xcode < 7.3 uses 340.4, so I assume we should be safe to go with this.
      url "http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/",
          :using => :svn
    end
  end

  def install
    (buildpath/"lldb").install resource("lldb")
    (buildpath/"tools/gyp").install resource("gyp")

    system "./gyp_llnode"
    system "make", "-C", "out/"
    prefix.install "out/Release/llnode.dylib"
  end

  def caveats; <<~EOS
    `brew install llnode` does not link the plugin to LLDB PlugIns dir.

    To load this plugin in LLDB, one will need to either

    * Type `plugin load #{opt_prefix}/llnode.dylib` on each run of lldb
    * Install plugin into PlugIns dir manually:

        mkdir -p ~/Library/Application\\ Support/LLDB/PlugIns
        ln -sf #{opt_prefix}/llnode.dylib \\
            ~/Library/Application\\ Support/LLDB/PlugIns/
    EOS
  end

  test do
    lldb_out = pipe_output "lldb", <<~EOS
      plugin load #{opt_prefix}/llnode.dylib
      help v8
      quit
    EOS
    assert_match "v8 bt", lldb_out
  end
end

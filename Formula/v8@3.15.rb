class V8AT315 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8-git-mirror/archive/3.15.11.18.tar.gz"
  sha256 "93a4945a550e5718d474113d9769a3c010ba21e3764df8f22932903cd106314d"

  bottle do
    cellar :any
    sha256 "39a784fe4a06f2b9dc50f98562b88ed1d258b40c4e3f59a5988be2655b4a9295" => :sierra
    sha256 "1b9d47411c74f8eb473760f09da571794621ca23f6f3a35d4328ff6fba587a03" => :el_capitan
    sha256 "87038130f14b74d791fe72ed17f0b05b54a3dbd598bcc4b3d598ee1f0cea362f" => :yosemite
  end

  keg_only :versioned_formula

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "f7bc250ccc4d619a1cf238db87e5979f89ff36d7"
  end

  def install
    (buildpath/"build/gyp").install resource("gyp")

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    system "make", "native",
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install "include"
    cd "out/native" do
      lib.install Dir["lib*"]
      bin.install "d8", "lineprocessor", "mksnapshot", "preparser", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end

class Ccls < Formula
  desc "C/C++ language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls.git", :tag => "0.20180513", :revision => "19d0aad2ca9663b5633b575efe41803005b21d38"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "558681d1f6d7abf9c229e1a36c160c50db3915fa9256071b62d29d382b338c89" => :high_sierra
    sha256 "56a447ad7d69f5df0b3e5e012e909b68c0030acef03ed5a2f7ebf846629ac3f7" => :sierra
    sha256 "fe5b6e7bfaf4be83251a752cbb557213edd0b266c24a53c223009e7b292d4f9d" => :el_capitan
  end

  option "without-system-clang", "Downloading Clang from http://releases.llvm.org/ during the configure process"

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    system_clang = build.with?("system-clang") ? "ON" : "OFF"

    args = std_cmake_args + %W[
      -DSYSTEM_CLANG=#{system_clang}
    ]

    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    if build.stable?
      ENV.append "LDFLAGS", "-lclangBasic"
    end

    mkdir_p "#{buildpath}/release"
    system "cmake", *args, "-Brelease", "-H."
    system "cmake", "--build", "release", "--target", "install"
  end

  test do
    system "#{bin}/ccls", "--test-unit"
  end
end

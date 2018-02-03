class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"

  stable do
    url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.6.tar.gz"
    sha256 "1bf0036415996af841884802161065b9e6be74f5f6808ac04831363e2549cdbf"

    # build with nasm when >=2.7 is released
    depends_on "yasm" => :build
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "1afc540af6dc55cccb6a5ca4e7f63b60677aa5899ed85acd73bdc2aaf0b93507" => :high_sierra
    sha256 "c6827e8190db07e717d958a6813902eea69f3ea67b15c40c3c8b4f61cd439bed" => :sierra
    sha256 "d70c032fd7061e0b82487e1b3174a09a8c2f6ec21a813df2a7acb40a4f2518d5" => :el_capitan
  end

  head do
    url "https://bitbucket.org/multicoreware/x265", :using => :hg

    depends_on "nasm" => :build
  end

  depends_on "cmake" => :build
  depends_on :macos => :lion

  def install
    # Build based off the script at ./build/linux/multilib.sh
    args = std_cmake_args + %w[
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
      -DEXTRA_LINK_FLAGS=-L.
      -DEXTRA_LIB=x265_main10.a;x265_main12.a
    ]
    high_bit_depth_args = std_cmake_args + %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    (buildpath/"8bit").mkpath

    mkdir "10bit" do
      system "cmake", buildpath/"source", *high_bit_depth_args
      system "make"
      mv "libx265.a", buildpath/"8bit/libx265_main10.a"
    end

    mkdir "12bit" do
      system "cmake", buildpath/"source", "-DMAIN12=ON", *high_bit_depth_args
      system "make"
      mv "libx265.a", buildpath/"8bit/libx265_main12.a"
    end

    cd "8bit" do
      system "cmake", buildpath/"source", *args
      system "make"
      mv "libx265.a", "libx265_main.a"
      system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                        "libx265_main10.a", "libx265_main12.a"
      system "make", "install"
    end
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end

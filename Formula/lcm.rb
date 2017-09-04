class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip"
  sha256 "3fd7c736cf218549dfc1bff1830000ad96f3d8a8d78d166904323b1df573ade1"

  bottle do
    cellar :any
    rebuild 2
    sha256 "9d6ddb03e294d3749e745cca34b2ace216a3b440d3a2f3f9876cbb32a019d718" => :sierra
    sha256 "ef469882185334519c17f849e4bd5ef452a64a11141a2cf99c7f1a8717f7382d" => :el_capitan
    sha256 "9fd05ae95e8fc4c0b2def87bdab3c24a9e57c72cfbb0c31e399584d25aad75b3" => :yosemite
  end

  head do
    url "https://github.com/lcm-proj/lcm.git"

    depends_on "xz" => :build
    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => :recommended
  depends_on :python => :optional
  depends_on :python3 => :optional

  def install
    if build.head?
      system "./bootstrap.sh"
    else
      # This deparallelize setting can be removed after an upstream release
      # that includes the revised makefile for the java part of LCM.
      #
      # (see https://github.com/lcm-proj/lcm/pull/48)
      #
      # Note that the pull request has been merged with the upstream master,
      # so it will be included in the next release of LCM.
      ENV.deparallelize
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"example_t.lcm").write <<-EOS.undent
      package exlcm;

      struct example_t
      {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    assert(File.exist?("exlcm_example_t.h"), "lcm-gen did not generate C header file")
    assert(File.exist?("exlcm_example_t.c"), "lcm-gen did not generate C source file")
    system "#{bin}/lcm-gen", "-x", "example_t.lcm"
    assert(File.exist?("exlcm/example_t.hpp"), "lcm-gen did not generate C++ header file")
    if build.with? "java"
      system "#{bin}/lcm-gen", "-j", "example_t.lcm"
      assert(File.exist?("exlcm/example_t.java"), "lcm-gen did not generate java file")
    end
  end
end

class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.073.0.tar.gz"
    sha256 "61483ea2c395341d05e65ce7e08a978cceff33ed3818f9ffa009a2f2da6929d5"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.073.0.tar.gz"
      sha256 "542adeac69b93c728a3760273d8d50ec43bf609736c526a58976b3822d5aa883"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.073.0.tar.gz"
      sha256 "2a0176039fcfcd6c05eff5f471e7659c2d368a8b2cd7f7de323d49d3d8b45782"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.073.0.tar.gz"
      sha256 "fbc04a5521eac7a25d9f210a44d9ae9b6843466ae4560f9dafe29d65771c2e06"
    end
  end

  bottle do
    rebuild 1
    sha256 "1ef54e6327af32e72f1eea4bc890871c29067c54c72f45f383fe2b29332eb6e0" => :sierra
    sha256 "1cad2eaa2edbffbca66ab01eb1a0d044447b2914c03cf026f54921be1860ddab" => :el_capitan
    sha256 "de02be09baa415d32836b4e9a59e639523308c97d4efce23355fed57be3b9ef6" => :yosemite
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.*"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end

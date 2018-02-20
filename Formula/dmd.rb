class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.078.2.tar.gz"
    sha256 "f59c25dadcd4597f487e734dac9c6526cabb9ad9f0af44d89422ac49709609c0"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.078.2.tar.gz"
      sha256 "cdc19bd245dbe60eb4d114ae79c7237e4766739182c655ab24a9ac26fa2309a0"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.078.2.tar.gz"
      sha256 "b1c8dd990318ea0d13d7962306250ec40c47516651909ec76acd157b67270b38"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.078.2.tar.gz"
      sha256 "56fbb061546995b8103a1c31260c5178ff3474cf3a99beca3e6aa3112515d52c"
    end
  end

  bottle do
    rebuild 1
    sha256 "2fa8ded5cd800f1af7022e1980b4769a0917ce9405c23182eec340cae4579f96" => :high_sierra
    sha256 "720a3ee819d6815a112a6955d45e2cefce5b8b04607fe5c513341de4020de21b" => :sierra
    sha256 "048c13d3579b42463107eff04ff3e09e227693a77b7c89ad0bf9c5f789dfe2ba" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.079.0-beta.1.tar.gz"
    sha256 "612ed09d9d9e1a6e6985ad61bb5c17649ecf2bb5169ebb5e512cef02372e9b26"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.079.0-beta.1.tar.gz"
      sha256 "d02d025c9a7af9477c1738cd257c11d90e69559724b87e903ec0a947a7542372"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.079.0-beta.1.tar.gz"
      sha256 "608135baec15774b7f4762d32b5b70fb7881d192a15b90f0716fee69bfe56e55"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.079.0-beta.1.tar.gz"
      sha256 "98421bac317439dc6f61f1d7df78c2a2a95c2e09cea9021c51f2c9e63c00396f"
    end
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

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    bin.install "generated/osx/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
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
    system bin/"dmd", pkgshare/"samples/hello.d"
    system "./hello"
  end
end

class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.074.1.tar.gz"
    sha256 "1e4191beaa6cce4ebf1810e01884b646b3bac7b098e1ae577a7f55be59dfc336"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.074.1.tar.gz"
      sha256 "c1171677ed1a3803e751feeacd8df82288872f78a5170471b7ca7c61631348cd"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.074.1.tar.gz"
      sha256 "2bec9f067256c7a1a8fcf62f8a59ae82f094479cfac0e385280afc6af23cbea8"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.074.1.tar.gz"
      sha256 "2fbaf425554210786b865d1e468698d46c48462b118a25a201ce1865445b217b"
    end
  end

  bottle do
    rebuild 1
    sha256 "5b146832eac327230b144f14e29b2f7dab4300bf48b7653f37570e457ba819d6" => :sierra
    sha256 "75f35ecf22cc2f11753ec4792fbb9449d8d60beeda881d0add97b1860f38cdd7" => :el_capitan
    sha256 "065bc7d1fd5e9a689bf5d30aa3364e699b754938a105fc462260a8cc9f9bdeb2" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.075.0-rc1.tar.gz"
    version "2.075.0-rc1"
    sha256 "1c2be5dfd0ca101a94425ada1acc67db137582133b07b98b42b7e48fbb45ef7f"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.075.0-rc1.tar.gz"
      version "2.075.0-rc1"
      sha256 "73cc1709fea7cfc85695e1c3e27e71ea08e4502268e4c257c73e6bf489efadd5"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.075.0-rc1.tar.gz"
      version "2.075.0-rc1"
      sha256 "e1db180d004dfd751961142afaefd92c1d0a3dd4f1a84937047c98fd1933e793"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.075.0-rc1.tar.gz"
      version "2.075.0-rc1"
      sha256 "f13e7f23ff53b4c0c277ef42f71332496d626d46ce29c6523d8f5f01c413d178"
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

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    if build.head?
      make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"
      (buildpath/"druntime").install resource("druntime")
      (buildpath/"phobos").install resource("phobos")
      system "make", "-C", "druntime", *make_args
      system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

      resource("tools").stage do
        inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
        system "make", "install", *make_args
      end

      (include/"dlang/dmd").install Dir["druntime/import/*"]
      cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
      lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

      conf = buildpath/"dmd.conf"
      # Can't use opt_include or opt_lib here because dmd won't have been
      # linked into opt by the time this build runs:
      conf.write <<-EOS.undent
          [Environment]
          DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
          EOS
      etc.install conf
    else
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
      lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

      resource("tools").stage do
        inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
        system "make", "install", *make_args
      end
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

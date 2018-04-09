class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.079.0.tar.gz"
    sha256 "e4fed191a05051dd262198ebbfd77e9e99fbad251b67b88b3394e2cca8a41893"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.079.0.tar.gz"
      sha256 "531910210e29c938ecee8ff6f39d2d247e892cae71811a684a504504bf1ea29b"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.079.0.tar.gz"
      sha256 "39cae5b9578925a9458654c64c9a85204b7598c685c2e48b7d4fcfc37d4a3550"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.079.0.tar.gz"
      sha256 "84598250c08ce1bdb9836a652c8ae09d8a5c429e60466b64df6c28fc9a24e684"
    end
  end

  bottle do
    rebuild 1
    sha256 "c54195ec0f183ddfa1ba3ee10b23b74c9d3941de34cc343f7da18f4c8e79ef6b" => :high_sierra
    sha256 "4bfe3858b6aa2348daf3d45ee1b36c8b7a12ce790629c6f082b2d62d0737c961" => :sierra
    sha256 "f248948c2dbdb7675b20c33bb4f03ef0e3d80f80042d60698a36d395a26cfa8b" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.079.1-beta.1.tar.gz"
    sha256 "8b2620dc0fb196ed7f9e9697cc83a644ec3a113a1af3a1222d9db6646aacdff9"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.079.1-beta.1.tar.gz"
      sha256 "6249a7a5ff71fe0365c3c85ff99999409c6b03c0c9694c7c1570764caae19e64"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.079.1-beta.1.tar.gz"
      sha256 "c19e01da5616ab3aed8f2642da6de608a54411cbc37add150b8c667dd032ef16"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.079.1-beta.1.tar.gz"
      sha256 "ffdac52441aaeaac9f247ef204938bbf5e8877a7c7ca09f87aeb29b7d1027eba"
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

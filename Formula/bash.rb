class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"

  head "http://git.savannah.gnu.org/r/bash.git"

  stable do
    url "https://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.3.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-4.3.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-4.3.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.46"

    %w[
      001 ecb3dff2648667513e31554b3ad054ccd89fce38e33367c9459ac3a285153742
      002 eee7cd7062ab29a9e4f02924d9c367264dcb8b162703f74ff6eb8f175a91502b
      003 000e6eac50cd9053ce0630db01239dcdead04a2c2c351c47e2b51dac1ac1087d
      004 5ea0a42c6506720d26e6d3c5c358e9a0d49f6f189d69a8ed34d5935964821338
      005 1ac83044032b9f5f11aeca8a344ae3c524ec2156185d3adbb8ad3e7a165aa3fa
      006 a0648ee72d15e4a90c8b77a5c6b19f8d89e28c1bc881657d22fe26825f040213
      007 1113e321c59cf6a8648a36245bbe4217cf8acf948d71e67886dad7d486f8f3a3
      008 9941a98a4987192cc5ce3d45afe879983cad2f0bec96d441a4edd9033767f95e
      009 c0226d6728946b2f53cdebf090bcd1c01627f01fee03295768605caa80bb40a5
      010 ce05799c0137314c70c7b6ea0477c90e1ac1d52e113344be8e32fa5a55c9f0b7
      011 7c63402cdbc004a210f6c1c527b63b13d8bb9ec9c5a43d5c464a9010ff6f7f3b
      012 3e1379030b35fbcf314e9e7954538cf4b43be1507142b29efae39eef997b8c12
      013 bfa8ca5336ab1f5ef988434a4bdedf71604aa8a3659636afa2ce7c7446c42c79
      014 5a4d6fa2365b6eb725a9d4966248b5edf7630a4aeb3fa8d526b877972658ac13
      015 13293e8a24e003a44d7fe928c6b1e07b444511bed2d9406407e006df28355e8d
      016 92d60bcf49f61bd7f1ccb9602bead6f2c9946d79dea0e5ec0589bb3bfa5e0773
      017 1267c25c6b5ba57042a7bb6c569a6de02ffd0d29530489a16666c3b8a23e7780
      018 7aa8b40a9e973931719d8cc72284a8fb3292b71b522db57a5a79052f021a3d58
      019 a7a91475228015d676cafa86d2d7aa9c5d2139aa51485b6bbdebfdfbcf0d2d23
      020 ca5e86d87f178128641fe91f2f094875b8c1eb2de9e0d2e9154f5d5cc0336c98
      021 41439f06883e6bd11c591d9d5e9ae08afbc2abd4b935e1d244b08100076520a9
      022 fd4d47bb95c65863f634c4706c65e1e3bae4ee8460c72045c0a0618689061a88
      023 9ac250c7397a8f53dbc84dfe790d2a418fbf1fe090bcece39b4a5c84a2d300d4
      024 3b505882a0a6090667d75824fc919524cd44cc3bd89dd08b7c4e622d3f960f6c
      025 1e5186f5c4a619bb134a1177d9e9de879f3bb85d9c5726832b03a762a2499251
      026 2ecc12201b3ba4273b63af4e9aad2305168cf9babf6d11152796db08724c214d
      027 1eb76ad28561d27f7403ff3c76a36e932928a4b58a01b868d663c165f076dabe
      028 e8b0dbed4724fa7b9bd8ff77d12c7f03da0fbfc5f8251ef5cb8511eb082b469d
      029 4cc4a397fe6bc63ecb97d030a4e44258ef2d4e076d0e90c77782968cc43d6292
      030 85434f8a2f379d0c49a3ff6d9ffa12c8b157188dd739e556d638217d2a58385b
      031 cd529f59dd0f2fdd49d619fe34691da6f0affedf87cc37cd460a9f3fe812a61d
      032 889357d29a6005b2c3308ca5b6286cb223b5e9c083219e5db3156282dd554f4a
      033 fb2a7787a13fbe027a7335aca6eb3c21cdbd813e9edc221274b6a9d8692eaa16
      034 f1694f04f110defe1330a851cc2768e7e57ddd2dfdb0e3e350ca0e3c214ff889
      035 370d85e51780036f2386dc18c5efe996eba8e652fc1973f0f4f2ab55a993c1e3
      036 ac5f82445b36efdb543dbfae64afed63f586d7574b833e9aa9cd5170bc5fd27c
      037 33f170dd7400ab3418d749c55c6391b1d161ef2de7aced1873451b3a3fca5813
      038 adbeaa500ca7a82535f0e88d673661963f8a5fcdc7ad63445e68bf5b49786367
      039 ab94dced2215541097691f60c3eb323cc28ef2549463e6a5334bbcc1e61e74ec
      040 84bb396b9262992ca5424feab6ed3ec39f193ef5c76dfe4a62b551bd8dd9d76b
      041 4ec432966e4198524a7e0cd685fe222e96043769c9613e66742ac475db132c1a
      042 ac219322db2791da87a496ee6e8e5544846494bdaaea2626270c2f73c1044919
      043 47a8a3c005b46e25821f4d8f5ccb04c1d653b1c829cb40568d553dc44f7a6180
      044 9338820630bf67373b44d8ea68409f65162ea7a47b9b29ace06a0aed12567f99
      045 ba6ec3978e9eaa1eb3fabdaf3cc6fdf8c4606ac1c599faaeb4e2d69864150023
      046 b3b456a6b690cd293353f17e22d92a202b3c8bce587ae5f2667c20c9ab6f688f
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftpmirror.gnu.org/bash/bash-4.3-patches/bash43-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.3-patches/bash43-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-4.3-patches/bash43-#{p}"
        mirror "https://ftp.gnu.org/gnu/bash/bash-4.3-patches/bash43-#{p}"
        mirror "https://gnu.cu.be/bash/bash-4.3-patches/bash43-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.3-patches/bash43-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "d2b6fc817178545e78be78a4eadf69a9d40b559b5246f4d850de0f69a0f3c79e" => :el_capitan
    sha256 "2cbb5cf87a3da713347934fd1c64ad33a4c4bf293e72bec482ec32ffed73f52e" => :yosemite
    sha256 "d8e78e912e10db0bf717c5958da825e5f01b2c80a80a41cb8cd2dbc14c0a2242" => :mavericks
  end

  devel do
    url "https://ftpmirror.gnu.org/bash/bash-4.4-rc2.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4-rc2.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4-rc2.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.4-rc2.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-4.4-rc2.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4-rc2.tar.gz"
    sha256 "199ec0166d50a765eec74dc258b006b06cf6b59901d7ff40510c82aae37ad994"
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    if build.devel? || build.head?
      system "./configure", "--prefix=#{prefix}"
    else
      system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    end
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end

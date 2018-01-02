class ScotchAT5 < Formula
  desc "Graph/mesh/hypergraph partitioning, clustering, and ordering"
  homepage "https://gforge.inria.fr/projects/scotch"
  url "https://gforge.inria.fr/frs/download.php/28978"
  version "5.1.12b"
  sha256 "82654e63398529cd3bcc8eefdd51d3b3161c0429bb11770e31f8eb0c3790db6e"
  revision 2

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  keg_only "conflicts with scotch (6.x)"

  depends_on :mpi => :cc

  # bugs in makefile:
  # - libptesmumps must be built before main_esmumps
  # - install should also install the lib*esmumps.a libraries
  patch :DATA

  def install
    cd "src" do
      # Use mpicc to compile the parallelized version
      make_args = ["CCS=#{ENV["CC"]}",
                   "CCP=#{ENV["MPICC"]}",
                   "CCD=#{ENV["MPICC"]}",
                   "RANLIB=echo"]
      ln_s "Make.inc/Makefile.inc.i686_mac_darwin8", "Makefile.inc"
      make_args += ["LIB=.dylib",
                    "AR=libtool",
                    "ARFLAGS=-dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o "]
      inreplace "Makefile.inc", "-O3", "-O3 -fPIC"

      system "make", "scotch", *make_args
      system "make", "ptscotch", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
    end
  end

  test do
    mktemp do
      system "echo cmplt 7 | #{bin}/gmap #{pkgshare}/grf/bump.grf.gz - bump.map"
      system "#{bin}/gmk_m2 32 32 | #{bin}/gmap - #{pkgshare}/tgt/h8.tgt brol.map"
      system "#{bin}/gout", "-Mn", "-Oi", "#{pkgshare}/grf/4elt.grf.gz", "#{pkgshare}/grf/4elt.xyz.gz", "-", "graph.iv"
    end
  end
end

__END__
diff -rupN scotch_5.1.12_esmumps/src/Makefile scotch_5.1.12_esmumps.patched/src/Makefile
--- scotch_5.1.12_esmumps/src/Makefile	2011-02-12 12:06:58.000000000 +0100
+++ scotch_5.1.12_esmumps.patched/src/Makefile	2013-08-07 14:56:06.000000000 +0200
@@ -105,6 +105,7 @@ install				:	required	$(bindir)	$(includ
 					-$(CP) -f ../bin/[agm]*$(EXE) $(bindir)
 					-$(CP) -f ../include/*scotch*.h $(includedir)
 					-$(CP) -f ../lib/*scotch*$(LIB) $(libdir)
+					-$(CP) -f ../lib/*esmumps*$(LIB) $(libdir)
 					-$(CP) -Rf ../man/* $(mandir)
 
 clean				:	required
diff -rupN scotch_5.1.12_esmumps/src/esmumps/Makefile scotch_5.1.12_esmumps.patched/src/esmumps/Makefile
--- scotch_5.1.12_esmumps/src/esmumps/Makefile	2010-07-02 23:31:06.000000000 +0200
+++ scotch_5.1.12_esmumps.patched/src/esmumps/Makefile	2013-08-07 14:48:30.000000000 +0200
@@ -59,7 +59,8 @@ scotch				:	clean
 
 ptscotch			:	clean
 					$(MAKE) CFLAGS="$(CFLAGS) -DSCOTCH_PTSCOTCH" CC=$(CCP) SCOTCHLIB=ptscotch ESMUMPSLIB=ptesmumps	\
-					libesmumps$(LIB)										\
+					libesmumps$(LIB)
+					$(MAKE) CFLAGS="$(CFLAGS) -DSCOTCH_PTSCOTCH" CC=$(CCP) SCOTCHLIB=ptscotch ESMUMPSLIB=ptesmumps	\
 					main_esmumps$(EXE)
 
 install				:

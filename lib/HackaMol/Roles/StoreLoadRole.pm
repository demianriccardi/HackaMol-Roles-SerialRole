package HackaMol::Roles::StoreLoadRole;

#ABSTRACT: Role to add store and load methods to HackaMol classes
use Moose::Role;
use Sereal::Encode;
use Sereal::Decode;
use Carp;

has 'format',   is => 'ro', isa => 'Str', lazy => 1, default => 'SEREAL';

#start simple, get something working and then make more sophisticated

sub store{
  #return pdb contents downloaded from pdb.org
  use LWP::Simple;
  my $self = shift;
  my $pdbid = _fix_pdbid(shift);  
  my $pdb = get($self->pdbserver.$pdbid);
  return ( $pdb );
}

sub load{
  #return array of lines from pdb downloaded from pdb.org
  use LWP::Simple;
  my $self = shift;
  my $pdbid = _fix_pdbid(shift);
  my $fpdbid = shift ;
  $fpdbid = $pdbid unless defined($fpdbid);
  if (-f $fpdbid and not $self->overwrite){
    carp "$fpdbid exists, set self->overwrite(1) to overwrite";
  }
  my $rc = getstore($self->pdbserver.$pdbid,$fpdbid);
  return ( $fpdbid, $rc );
}

no Moose::Role;
1;

__END__

=head1 SYNOPSIS

   use HackaMol;

   my $pdb = $HackaMol->new->get_pdbid("2cba");
   print $pdb;

=head1 DESCRIPTION

FileFetchRole provides attributes and methods for pulling files from the internet.
Currently, the Role has one method and one attribute for interacting with the Protein Database.

=method get_pdbid 

fetches a pdb from pdb.org and returns the file in a string.

=method getstore_pdbid 

arguments: pdbid and filename for writing (optional). 
Fetches a pdb from pdb.org and stores it in your working directory unless {it exists and overwrite(0)}. If a filename is not
passed to the method, it will write to $pdbid.pdb. use get_pdbid to return contents

=attr overwrite    
 
isa lazy ro Bool that defaults to 0 (false).  If overwrite(1), then fetched files will be able to overwrite
those of same name in working directory.

=attr  pdbserver  

isa lazy rw Str that defaults to http://pdb.org/pdb/files/

=head1 SEE ALSO

=for :list
* L<http://www.pdb.org>
* L<LWP::Simple>
                              

# cstore-0.2-centos7-docker
This docker image contains the [C-Store database](http://db.lcs.mit.edu/projects/cstore/) created as a collaboration between
MIT, Yale, Brandeis University, Brown University, and UMass Boston. 
Being unaffiliated with the team that created it, I was still interested in running sample queries, and this image is a byproduct.

There are 2 branches corresponding to 2 versions of the image; one just builds the system, another bases on pre-built system and fetches sample data. The version with data is slightly space-hungry, the compressed image size is around 7G.

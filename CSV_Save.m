%%
matrix1 = {'water';'space';'fire'};
matrix2 = [100;200;300];
%%
fid = fopen( 'matrix.csv', 'w' );
for jj = 1 : length( matrix1 )
    fprintf( fid, '%s,%d/n', matrix1{jj}, matrix2(jj) );
end
fclose( fid );
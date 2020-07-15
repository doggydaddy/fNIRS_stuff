function output = mat2txt(input_mat_file, output_txt_file)
    tmp_file=load(input_mat_file);
    beta_values=tmp_file.S.cbeta;
    chnl=1:16;
    output=[chnl; beta_values];
    output=output.';
    writetable(array2table(output), output_txt_file);
end
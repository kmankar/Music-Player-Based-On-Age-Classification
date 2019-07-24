function mapping_age(class)
    folder_name = num2str(class);
    main_folder = 'Songs\';
    post_name = '\';
    path = strcat(main_folder,folder_name,post_name);
    save('name','path');
    audio_player();
end
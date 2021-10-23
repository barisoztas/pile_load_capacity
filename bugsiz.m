function varargout = bugsiz(varargin)
% BUGSIZ MATLAB code for bugsiz.fig
%      BUGSIZ, by itself, creates a new BUGSIZ or raises the existing
%      singleton*.
%
%      H = BUGSIZ returns the handle to a new BUGSIZ or the handle to
%      the existing singleton*.
%
%      BUGSIZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUGSIZ.M with the given input arguments.
%
%      BUGSIZ('Property','Value',...) creates a new BUGSIZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bugsiz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bugsiz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bugsiz

% Last Modified by GUIDE v2.5 26-Dec-2020 19:36:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bugsiz_OpeningFcn, ...
                   'gui_OutputFcn',  @bugsiz_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bugsiz is made visible.
function bugsiz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bugsiz (see VARARGIN)

% Choose default command line output for bugsiz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bugsiz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bugsiz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_layer_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_layer_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pop_layer_menu, 'value', 1);

% Hints: get(hObject,'String') returns contents of edit_layer_number as text
%        str2double(get(hObject,'String')) returns contents of edit_layer_number as a double


% --- Executes during object creation, after setting all properties.
function edit_layer_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_layer_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pub_save_layer_number.
function pub_save_layer_number_Callback(hObject, eventdata, handles)
% hObject    handle to pub_save_layer_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pop_layer_menu,'Enable','on');
handles.layer_number = str2double (handles.edit_layer_number.String);       %save the layer number

%% update pop menu of layers
text = {};                                                                  
for i=1:handles.layer_number+1
    if i==1
        text{i} = 'Select the Layer';
    else    
        i_str = num2str(i-1);
        text{i} = ['Layer ', i_str ];
    end
end
text = text';

set (handles.pop_layer_menu,'String',text);
%% Update table
text = {};
for i=1:handles.layer_number
  
        i_str = num2str(i);
        text{i} = ['Layer ', i_str ];
    
end
text = text';

empty_cell = {'','','','','','','',''};

set (handles.layer_table,'RowName',text);
% set(handles.layer_table,'Data',cell(1,8));
set(handles.layer_table,'Data',empty_cell);
handles.fake    =   empty_cell;

% Update handles structure
guidata(hObject, handles);

a=1;


%%


% --- Executes on button press in pub_calculate.
function pub_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pub_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Get datas from table and other edit text boxes

set(handles.text29,'Visible',"on");

datatable=handles.layer_table.Data;
cu = str2double(datatable(:,5))';
sat_unit_weight = str2double(datatable(:,4))';
z_start         = str2double(datatable(:,2))';
z_end           = str2double(datatable(:,3))';
adhesion_factor = str2double(datatable(:,6))';
friction_angle  = str2double(datatable(:,7))';
nq              = str2double(datatable(:,8))';
pile_diameter   = get(handles.edit_pile_diameter,'String');
pile_diameter   = str2double(pile_diameter);
pile_length     = get(handles.edit_pile_length,'String');
pile_length     = str2double(pile_length);
zcr = 15 * pile_diameter;
layer_number    = get(handles.edit_layer_number,'String');
layer_number    = str2double(layer_number);
nc  = 9;


%% calculation and drawing the result


z = [z_start z_end(end)];   % 	continuous z array from 0 to last layer's end depth


%% placing critical depth to z array
for i=1:length(z)
    
    if z(i)<zcr
        
    else
        z = [z(1:i-1) zcr z(i:end)];
        cr = i;
        break
    end
    
end

%% changing to z array according to length of the pile

 for i=1:length(z)
        if z(i) < pile_length
            
        else
            z(i) = pile_length;
            z( [i+1:end] ) = [];
            k = i;
            break       
        end
    end
%% soil properties corresponding each z value from 0 to pile length

z_check = [z_start z_end(end)];         % continuous z array from 0 to last layer's end depth in order to compare each z(i) with layer boundaries

for i=2:length(z)
    k(1) = 1;
    unit_weight(1) = sat_unit_weight(1);
    a_f(1) = adhesion_factor(1);
    shear_strength(1) = cu(1);
    f_angle(1) = friction_angle(1);
    nq_updated (1) = nq(1);
    for j=1:length(z_check)
        if z(i)<= z_check(j)
            k(i) = j-1;
            unit_weight(i) = sat_unit_weight(j-1);
            a_f(i) = adhesion_factor(j-1);
            shear_strength(i) = cu(j-1);
            f_angle(i) = friction_angle(j-1);
            nq_updated (i) = nq(j-1);
            break               %break after length of the pile. because other information is not necessary for our calculations
        else
        end
    end
end

clear sat_unit_weight adhesion_factor cu friction_angle nq;  % we don't need them anymore


     
%% effective vertical stress corresponding each z value && drawing of layers/pile_figure/eff_vo-z

%% we need to calculate it with external function
% for i=1:length(z) 
%     if i==1
%         eff_vo(i) = z(i) .* unit_weight(i);
%     elseif zcr==z(i)
%         eff_vo(i) = eff_vo(i-1) + (z(i)-z(i-1))*(unit_weight(i)-9.81);
%         eff_vo(i:length(z)) = eff_vo(i);
%         break
%     else
%         eff_vo(i) = eff_vo(i-1) + (z(i)-z(i-1))*(unit_weight(i)-9.81);
%        
%     end
% end
%%

eff_vo = effective_stress_calculator(z,unit_weight,zcr);

eff_vo_corrected = eff_vo ./ 20;
%% plot eff_vo-z

eff_vo_corrected=eff_vo./20;
plot(eff_vo_corrected,-z,'LineWidth',3,'Color','r');
xlim([-10 12]);
ylim([-z_end(end)-2 -z(1)]);
width=2;

%% plot pile as rectangle
pile_figure=rectangle('Position', [-8,-pile_length,width,pile_length], ...
'EdgeColor',[0.2 0.22 0.2], 'FaceColor', [0.2 0.22 0.2]);
xticks([]);

%% update x-y axis ticks
z_check = [z_start z_end(end)]
z_check = [z_check pile_length]
z_check = unique(z_check)
z_check = -z_check(:,[end:-1:1]);
yticks([z_check]);
line([0 0],[-z(1) -z(end)],'LineWidth',2,'Color',[0 0 0],'LineWidth', 2);

%% placing layer number text to each layer

for i=1:layer_number
    line([-10 12], [-z_end(i) -z_end(i)],'LineWidth',2,'Color',[0 0 0], ...
    'LineWidth', 2);
    txt = ['Layer ', num2str(i)] ;
    text(8,-z_end(i)+2,txt);          
end

%% placing eff_vo value to each important points

for i=1:length(z)
    if z(i)==zcr
        text(eff_vo_corrected(i)+0.3,-z(i), [num2str(eff_vo(i)), ...
            '   (Dcr= ', num2str(zcr), 'm)'] );
    elseif i==1
        text(eff_vo_corrected(i)+0.3,-z(i)-0.2, mat2str(eff_vo(i)));
    else
        text(eff_vo_corrected(i)+0.3,-z(i)+0.35, mat2str(eff_vo(i)));
    end
end




%% calculations of qs and qt



for i=1:length(z)-1
    if shear_strength(i+1)~=0
        qs(i) = pi * pile_diameter * a_f(i+1) * shear_strength(i+1) * (z(i+1)-z(i));
    else
        qs(i) = pi * pile_diameter * 0.5 * (eff_vo(i+1)+eff_vo(i))/2 * tand(0.75*f_angle(i+1)) * (z(i+1)-z(i));
    end
end

if shear_strength(end)~=0
    qp = nc * shear_strength(end) * pi * pile_diameter^2 / 4; 
else
    qp = nq_updated(end) * eff_vo(end) * pi * pile_diameter^2 / 4; 
end

set(handles.edit_tip_resistance,'String',qp);
set(handles.edit_skin_friction,'String',sum(qs));

qs = sum(qs);
total = num2str(qs + qp);
format long
set(handles.edit_ult_capacity,'String',total);


%%


% --- Executes on selection change in pop_layer_menu.
function pop_layer_menu_Callback(hObject, eventdata, handles)
% hObject    handle to pop_layer_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update Soil type table's title
set(handles.uibuttongroup1,'Visible','on');
contents = get(hObject,'Value');
set(handles.uibuttongroup1,'title', ['Layer ' num2str(contents-1), ' Soil Type']);

%% update layer panel

set (handles.panel_layer_prop,'title',['Layer ', num2str(contents-1), ' Properties'] );

%% update "save layer" pushbutton.
set (handles.pub_save_layer,'String',['Save the Layer ', num2str(contents-1)] );

% Hints: contents = cellstr(get(hObject,'String')) returns pop_layer_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_layer_menu

%% update layer panel's edit text boxes

handles.edit_starting_depth.String  = '0';
handles.edit_end_depth.String       = '0';
handles.edit_unit_weight.String     = '0';
handles.edit_cu.String              = '0';
handles.edit_adhesion_factor.String = '0';
handles.edit_friction_angle.String  = '0';
handles.edit_nq.String              = '0';

%% update start depth and make it previous layer's end depth, if possible.
if contents-1~=0
    try
    
        start_case = handles.layer_table.Data (contents-1,2);
        start_case = convertCharsToStrings(start_case);    
        set(handles.edit_starting_depth,'String', [start_case])  ;
    catch
    
    end
else
    
end


% --- Executes during object creation, after setting all properties.
function pop_layer_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_layer_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pile_length_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pile_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!


% Hints: get(hObject,'String') returns contents of edit_pile_length as text
%        str2double(get(hObject,'String')) returns contents of edit_pile_length as a double


% --- Executes during object creation, after setting all properties.
function edit_pile_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pile_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pile_diameter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pile_diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!



% Hints: get(hObject,'String') returns contents of edit_pile_diameter as text
%        str2double(get(hObject,'String')) returns contents of edit_pile_diameter as a double


% --- Executes during object creation, after setting all properties.
function edit_pile_diameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pile_diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_skin_friction_Callback(hObject, eventdata, handles)
% hObject    handle to edit_skin_friction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_skin_friction as text
%        str2double(get(hObject,'String')) returns contents of edit_skin_friction as a double


% --- Executes during object creation, after setting all properties.
function edit_skin_friction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_skin_friction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tip_resistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tip_resistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tip_resistance as text
%        str2double(get(hObject,'String')) returns contents of edit_tip_resistance as a double


% --- Executes during object creation, after setting all properties.
function edit_tip_resistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tip_resistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ult_capacity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ult_capacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ult_capacity as text
%        str2double(get(hObject,'String')) returns contents of edit_ult_capacity as a double


% --- Executes during object creation, after setting all properties.
function edit_ult_capacity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ult_capacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_starting_depth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_starting_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_starting_depth as text
%        str2double(get(hObject,'String')) returns contents of edit_starting_depth as a double


% --- Executes during object creation, after setting all properties.
function edit_starting_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_starting_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_depth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_end_depth as text
%        str2double(get(hObject,'String')) returns contents of edit_end_depth as a double


% --- Executes during object creation, after setting all properties.
function edit_end_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_unit_weight_Callback(hObject, eventdata, handles)
% hObject    handle to edit_unit_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_unit_weight as text
%        str2double(get(hObject,'String')) returns contents of edit_unit_weight as a double


% --- Executes during object creation, after setting all properties.
function edit_unit_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_unit_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_cu as text
%        str2double(get(hObject,'String')) returns contents of edit_cu as a double


% --- Executes during object creation, after setting all properties.
function edit_cu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_nq as text
%        str2double(get(hObject,'String')) returns contents of edit_nq as a double


% --- Executes during object creation, after setting all properties.
function edit_nq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_adhesion_factor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_adhesion_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% no updating data because, we want to do that when user press save layer
% pub!!!!!

% Hints: get(hObject,'String') returns contents of edit_adhesion_factor as text
%        str2double(get(hObject,'String')) returns contents of edit_adhesion_factor as a double


% --- Executes during object creation, after setting all properties.
function edit_adhesion_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_adhesion_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_friction_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_friction_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% no updating data because, we want to do that when user press save layer
% pub!!!!!
% Hints: get(hObject,'String') returns contents of edit_friction_angle as text
%        str2double(get(hObject,'String')) returns contents of edit_friction_angle as a double


% --- Executes during object creation, after setting all properties.
function edit_friction_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_friction_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% making some edit text boxes disable and show their value as 0
set(handles.panel_layer_prop,'Visible','on');

set(handles.edit_friction_angle,'String','0');
set(handles.edit_friction_angle,'Enable','off');
set(handles.edit_nq,'Enable','off');
set(handles.edit_nq,'String','0');

set(handles.edit_cu,'String','0');
set(handles.edit_cu,'Enable','on');
set(handles.edit_adhesion_factor,'Enable','on');
set(handles.edit_adhesion_factor,'String','0');

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% making some edit text boxes disable and show their value as 0

set(handles.panel_layer_prop,'Visible','on');
set(handles.edit_cu,'String','0');
set(handles.edit_cu,'Enable','off');
set(handles.edit_adhesion_factor,'Enable','off');
set(handles.edit_adhesion_factor,'String','0');

set(handles.edit_friction_angle,'String','0');
set(handles.edit_friction_angle,'Enable','on');
set(handles.edit_nq,'Enable','on');
set(handles.edit_nq,'String','0');
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pub_save_layer.
function pub_save_layer_Callback(hObject, eventdata, handles)
% hObject    handle to pub_save_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% if this button is clicked this text will occur

layer= get(handles.pop_layer_menu,'Value');
set(handles.pub_save_layer,'String',['Layer ', num2str(layer-1),' is saved!']);

%% Update the table 

if handles.radiobutton1.Value == 1      %%get soil type
    soil_type = get(handles.radiobutton1,'String');
else
    soil_type = 'Cohesionless';
end

% get other parameters of soil

starting_depth      = {handles.edit_starting_depth.String};
starting_depth      = string(starting_depth);
starting_depth      = convertStringsToChars(starting_depth);
end_depth           = handles.edit_end_depth.String;
unit_weight         = handles.edit_unit_weight.String;
uss_cu              = handles.edit_cu.String;
adhesion_factor     = handles.edit_adhesion_factor.String;
friction_angle      = handles.edit_friction_angle.String;
nq                  = handles.edit_nq.String;



% layer_props(layer-1).f = {soil_type, starting_depth, end_depth, ...
%     unit_weight, uss_cu, adhesion_factor, friction_angle, nq };
% 
% layer_props = layer_props(layer-1).f;

% % % handles.fake            = 


handles.fake(layer-1,:) = {soil_type, starting_depth, end_depth, unit_weight, uss_cu, adhesion_factor, friction_angle, nq };



% fake= handles.layer_table.DisplayData(:,[1:8]);
% fake (layer-1,:)=layer_props;
%% update next layer's starting depth, if possible
try
 
     if layer==length(handles.pop_layer_menu.String)
         
     else
         handles.fake (layer,2) = handles.fake(layer-1,3);
     end

         catch
    
end

set(handles.layer_table,'Data', handles.fake);      % update table

% Update handles structure
guidata(hObject, handles);

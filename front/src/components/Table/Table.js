import React from "react";

const Table = ({list, colNames, width="auto", height="auto"}) => {
   return (
      <div style={ {boxShadow: '3px 6px 3px #ccc'}}>
         {list.length > 0 && (
            <table cellSpacing="0" style={{width: width, height: height, padding: '5px 10px'}}>
               <thead>
                  <tr>
                     {colNames.map((headerItem, index) => (
                        <th key={index}>
                           {headerItem.toUpperCase()}
                        </th>
                     ))}
                  </tr>
               </thead>
               <tbody>
                  {Object.values(list).map((obj, index) => (
                     <tr key={index}>
                        {Object.values(obj).map((value, index2) => (
                           <td key={index2}>
                              {value}
                           </td>
                        ))}
                     </tr>
                  ))}
               </tbody>
            </table>
         )}
      </div>
   )
}

export default Table;